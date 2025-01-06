-- Verilen AbonelikID�de kullan�lan paketi YeniPaketID ile de�i�tirir. 
-- ��lemler s�ras�nda bir hata olmas� durumunda yap�lan i�lemler geri al�n�r.
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

        -- �imdi kullan�lan paketi ve m��teri bilgilerini al
        SELECT @EskiPaketID = PaketID, @MusteriID = MusteriID
        FROM Abonelikler
        WHERE AbonelikID = @AbonelikID;

        IF @EskiPaketID IS NULL
        BEGIN
            THROW 51004, 'Abonelik bulunamad�.', 1;
        END

        -- Aboneli�i yeni paket ile g�ncelle
        UPDATE Abonelikler
        SET PaketID = @YeniPaketID
        WHERE AbonelikID = @AbonelikID;

        -- Yeni paket i�in fatura olu�tur
        DECLARE @YeniUcret DECIMAL(10,2);
        SELECT @YeniUcret = AylikUcret
        FROM Paketler
        WHERE PaketID = @YeniPaketID;

        INSERT INTO Faturalar (AbonelikID, FaturaTarihi, SonOdemeTarihi, FaturaTutari, Durum)
        VALUES (@AbonelikID, GETDATE(), DATEADD(DAY, 30, GETDATE()), @YeniUcret, 0);

        -- LogTipiID'yi dinamik olarak belirle
        SELECT @VarlikTipiID = VarlikTipiID
        FROM LogVarlikTipleri
        WHERE VarlikTipi = 'Abonelik'; -- Abonelik i�lemleri i�in uygun varl�k tipi

        SELECT @LogTipiID = LogTipiID
        FROM LogTipleri
        WHERE IslemTipi = 'Paket Degistirildi' AND VarlikTipiID = @VarlikTipiID;

        -- De�i�ikli�i loga kaydet
        INSERT INTO SistemLoglari (VarlikID, LogTipiID, IslemTarihi, Ayrintilar)
        VALUES (
            @AbonelikID,
            @LogTipiID,
            GETDATE(),
            CONCAT('Paket de�i�tirildi: Eski Paket ID = ', @EskiPaketID, ', Yeni Paket ID = ', @YeniPaketID)
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
