-- Verilen AbonelikID’de kullanýlan paketi YeniPaketID ile deðiþtirir. 
-- Ýþlemler sýrasýnda bir hata olmasý durumunda yapýlan iþlemler geri alýnýr.
CREATE PROCEDURE sp_PaketDegistir
    @AbonelikID INT,
    @YeniPaketID INT
AS
BEGIN
    DECLARE @EskiPaketID INT;
    DECLARE @MusteriID INT;
    DECLARE @LogTipiID INT;
    DECLARE @VarlikTipiID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Þimdi kullanýlan paketi ve müþteri bilgilerini al
        SELECT @EskiPaketID = PaketID, @MusteriID = MusteriID
        FROM Abonelikler
        WHERE AbonelikID = @AbonelikID;

        IF @EskiPaketID IS NULL
        BEGIN
            THROW 51004, 'Abonelik bulunamadý.', 1;
        END

        -- Aboneliði yeni paket ile güncelle
        UPDATE Abonelikler
        SET PaketID = @YeniPaketID
        WHERE AbonelikID = @AbonelikID;

        -- Yeni paket için fatura oluþtur
        DECLARE @YeniUcret DECIMAL(10,2);
        SELECT @YeniUcret = AylikUcret
        FROM Paketler
        WHERE PaketID = @YeniPaketID;

        INSERT INTO Faturalar (AbonelikID, FaturaTarihi, SonOdemeTarihi, FaturaTutari, Durum)
        VALUES (@AbonelikID, GETDATE(), DATEADD(DAY, 30, GETDATE()), @YeniUcret, 0);

        -- LogTipiID'yi dinamik olarak belirle
        SELECT @VarlikTipiID = VarlikTipiID
        FROM LogVarlikTipleri
        WHERE VarlikTipi = 'Abonelik'; -- Abonelik iþlemleri için uygun varlýk tipi

        SELECT @LogTipiID = LogTipiID
        FROM LogTipleri
        WHERE IslemTipi = 'Paket Degistirildi' AND VarlikTipiID = @VarlikTipiID;

        -- Deðiþikliði loga kaydet
        INSERT INTO SistemLoglari (VarlikID, LogTipiID, IslemTarihi, Ayrintilar)
        VALUES (
            @AbonelikID,
            @LogTipiID,
            GETDATE(),
            CONCAT('Paket deðiþtirildi: Eski Paket ID = ', @EskiPaketID, ', Yeni Paket ID = ', @YeniPaketID)
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
