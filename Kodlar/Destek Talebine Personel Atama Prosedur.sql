-- Mevcuttaki bir destek talebine bir personel atar. 
-- Eðer iþlemler sýrasýnda bir hata olursa yapýlan iþlemleri geri alýr ve kodu bitirir.
CREATE PROCEDURE sp_TeknikDestekAtama
    @DestekTalepID INT,
    @PersonelID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
			-- Verilen destek talebi mevcut mu veya baþka bir personel atanmýþ mý?
            IF NOT EXISTS (
                SELECT 1 
                FROM TeknikDestekTalepleri 
                WHERE DestekTalepID = @DestekTalepID 
                AND PersonelID IS NULL
            )
            BEGIN
                THROW 51009, 'Destek talebi bulunamadý veya daha önce atanmýþ', 1;
            END

			-- Personel mevcut mu?
            IF NOT EXISTS (
                SELECT 1 
                FROM Personel 
                WHERE PersonelID = @PersonelID
            )
            BEGIN
                THROW 51010, 'Personel bulunamadý', 1;
            END

			-- 'Atandý' durumu için DestekDurumID'yi bul
            DECLARE @AtandiDurumID INT;
            SELECT @AtandiDurumID = DestekDurumID 
            FROM TeknikDestekDurumlari 
            WHERE Durum = 'Atandý';

			-- Destek talebini güncelle
            UPDATE TeknikDestekTalepleri
            SET 
                PersonelID = @PersonelID,
                DurumID = @AtandiDurumID
            WHERE DestekTalepID = @DestekTalepID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
		THROW 51011, 'Atama yaparken hata oluþtu. Rollback yapýldý', 1;
        THROW;
    END CATCH
END;