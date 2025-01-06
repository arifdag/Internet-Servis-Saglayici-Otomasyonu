-- Verilen AbonelikID�ye sahip aboneli�i ve son faturay� iptal eder. 
-- Ard�ndan verilen IptalNedini�ni kullanarak yeni bir log olu�turur. 
-- Bu i�lemler s�ras�nda herhangi bir hata olu�ursa yap�lan t�m i�lemler geri al�n�r.
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
            THROW 51005, 'Abonelik bulunamad� veya zaten iptal edilmi�.', 1;
        END

		-- Loga y�klemek i�in abonelik detaylar�n� al
        DECLARE @MusteriID INT;
        SELECT @MusteriID = MusteriID
        FROM Abonelikler
        WHERE AbonelikID = @AbonelikID;

		-- Aboneli�in biti� tarihi ve durumunu g�ncelle
        UPDATE Abonelikler
        SET 
            Durum = 0,
            BitisTarihi = GETDATE()
        WHERE AbonelikID = @AbonelikID;

        -- �denmemi� faturalar� iptal et
        UPDATE Faturalar
        SET Durum = 1
        WHERE AbonelikID = @AbonelikID 
        AND Durum = 0 
        AND FaturaTarihi <= GETDATE();

        -- Bu abonelikle ilgili cihazlar� deaktif et
        UPDATE Cihazlar
        SET 
            Durum = 0,
            AbonelikID = NULL
        WHERE AbonelikID = @AbonelikID;

		-- Log i�in gerekli LogTipiID'yi bul
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
        THROW 51006, 'Abonelik iptali s�ras�nda hata olu�tu.', 1;
    END CATCH
END;