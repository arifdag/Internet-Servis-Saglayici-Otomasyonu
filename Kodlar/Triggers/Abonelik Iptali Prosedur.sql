-- Verilen AbonelikID’ye sahip aboneliði ve son faturayý iptal eder. 
-- Ardýndan verilen IptalNedini’ni kullanarak yeni bir log oluþturur. 
-- Bu iþlemler sýrasýnda herhangi bir hata oluþursa yapýlan tüm iþlemler geri alýnýr.
CREATE PROCEDURE sp_AbonelikIptal
    @AbonelikID INT,
    @IptalNedeni NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            
		-- Abonelik mevcut mu veya aktif mi kontrol et.
        IF NOT EXISTS (SELECT 1 FROM Abonelikler WHERE AbonelikID = @AbonelikID AND Durum = 1)
        BEGIN
            THROW 51005, 'Abonelik bulunamadý veya zaten iptal edilmiþ.', 1;
        END

		-- Loga yüklemek için abonelik detaylarýný al
        DECLARE @MusteriID INT;
        SELECT @MusteriID = MusteriID
        FROM Abonelikler
        WHERE AbonelikID = @AbonelikID;

		-- Aboneliðin bitiþ tarihi ve durumunu güncelle
        UPDATE Abonelikler
        SET 
            Durum = 0,
            BitisTarihi = GETDATE()
        WHERE AbonelikID = @AbonelikID;

        -- Ödenmemiþ faturalarý iptal et
        UPDATE Faturalar
        SET Durum = 1
        WHERE AbonelikID = @AbonelikID 
        AND Durum = 0 
        AND FaturaTarihi <= GETDATE();

        -- Bu abonelikle ilgili cihazlarý deaktif et
        UPDATE Cihazlar
        SET 
            Durum = 0,
            AbonelikID = NULL
        WHERE AbonelikID = @AbonelikID;

		-- Log için gerekli LogTipiID'yi bul
        DECLARE @LogTipiID INT;
        SELECT @LogTipiID = lt.LogTipiID
        FROM LogTipleri lt
        INNER JOIN LogVarlikTipleri lvt ON lt.VarlikTipiID = lvt.VarlikTipiID
        WHERE lvt.VarlikTipi = 'Abonelik'
        AND lt.IslemTipi = 'Abonelik Sonlandi';

		-- Logla
        INSERT INTO SistemLoglari (VarlikID, LogTipiID, IslemTarihi, Ayrintilar)
        VALUES (
            @AbonelikID,
            @LogTipiID,
            GETDATE(),
            CONCAT('Abonelik iptal edildi. Sebep: ', @IptalNedeni)
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW 51006, 'Abonelik iptali sýrasýnda hata oluþtu.', 1;
    END CATCH
END;