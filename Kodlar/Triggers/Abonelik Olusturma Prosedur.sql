-- Verilen MusteriID, PaketID ve BaslangicTarihi’ni kullanarak yeni bir abonelik baþlatýr ve ilk faturayý keser. 
-- Eðer bir hata oluþursa yapýlan iþlemleri geri alýr.
CREATE PROCEDURE sp_YeniAbonelikOlustur
    @MusteriID INT,
    @PaketID INT,
    @BaslangicTarihi DATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            
        -- Musteri var mý kontrol et. Yoksa hata ver.
        IF NOT EXISTS (SELECT 1 FROM Musteriler WHERE MusteriID = @MusteriID)
        BEGIN
            THROW 51000, 'Müþteri bulunamadý.', 1;
        END

        -- Paket var mý ve varsa aktif mi kontrol et. Yoksa hata ver.
        IF NOT EXISTS (SELECT 1 FROM Paketler WHERE PaketID = @PaketID AND Durum = 1)
        BEGIN
            THROW 51001, 'Paket bulunamadý veya aktif deðil.', 1;
        END

        -- Yeni abonelik Olustur
        INSERT INTO Abonelikler (MusteriID, PaketID, BaslangicTarihi, Durum)
        VALUES (@MusteriID, @PaketID, @BaslangicTarihi, 1);

        -- AbonelikId'yi al
        DECLARE @AbonelikID INT = SCOPE_IDENTITY();

        -- Ýlk Faturayý olustur
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
        THROW 51002, 'Hata oluþtu, iþlemler geri alýndý', 1;
    END CATCH
END;