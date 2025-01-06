-- Verilen MusteriID, PaketID ve BaslangicTarihi�ni kullanarak yeni bir abonelik ba�lat�r ve ilk faturay� keser. 
-- E�er bir hata olu�ursa yap�lan i�lemleri geri al�r.
CREATE PROCEDURE sp_YeniAbonelikOlustur
    @MusteriID INT,
    @PaketID INT,
    @BaslangicTarihi DATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            
        -- Musteri var m� kontrol et. Yoksa hata ver.
        IF NOT EXISTS (SELECT 1 FROM Musteriler WHERE MusteriID = @MusteriID)
        BEGIN
            THROW 51000, 'M��teri bulunamad�.', 1;
        END

        -- Paket var m� ve varsa aktif mi kontrol et. Yoksa hata ver.
        IF NOT EXISTS (SELECT 1 FROM Paketler WHERE PaketID = @PaketID AND Durum = 1)
        BEGIN
            THROW 51001, 'Paket bulunamad� veya aktif de�il.', 1;
        END

        -- Yeni abonelik Olustur
        INSERT INTO Abonelikler (MusteriID, PaketID, BaslangicTarihi, Durum)
        VALUES (@MusteriID, @PaketID, @BaslangicTarihi, 1);

        -- AbonelikId'yi al
        DECLARE @AbonelikID INT = SCOPE_IDENTITY();

        -- �lk Faturay� olustur
        DECLARE @FaturaTutari DECIMAL(10,2);
        SELECT @FaturaTutari = AylikUcret 
        FROM Paketler 
        WHERE PaketID = @PaketID;

        INSERT INTO Faturalar (AbonelikID, FaturaTarihi, SonOdemeTarihi, FaturaTutari, Durum)
        VALUES (@AbonelikID, @BaslangicTarihi, DATEADD(DAY, 30, @BaslangicTarihi), @FaturaTutari, 0);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW 51002, 'Hata olu�tu, i�lemler geri al�nd�', 1;
    END CATCH
END;