-- Mevcuttaki bir destek talebine bir personel atar. 
-- E�er i�lemler s�ras�nda bir hata olursa yap�lan i�lemleri geri al�r ve kodu bitirir.
CREATE PROCEDURE sp_TeknikDestekAtama
    @DestekTalepID INT,
    @PersonelID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
			-- Verilen destek talebi mevcut mu veya ba�ka bir personel atanm�� m�?
            IF NOT EXISTS (
                SELECT 1 
                FROM TeknikDestekTalepleri 
                WHERE DestekTalepID = @DestekTalepID 
                AND PersonelID IS NULL
            )
            BEGIN
                THROW 51009, 'Destek talebi bulunamad� veya daha �nce atanm��', 1;
            END

			-- Personel mevcut mu?
            IF NOT EXISTS (
                SELECT 1 
                FROM Personel 
                WHERE PersonelID = @PersonelID
            )
            BEGIN
                THROW 51010, 'Personel bulunamad�', 1;
            END

			-- 'Atand�' durumu i�in DestekDurumID'yi bul
            DECLARE @AtandiDurumID INT;
            SELECT @AtandiDurumID = DestekDurumID 
            FROM TeknikDestekDurumlari 
            WHERE Durum = 'Atand�';

			-- Destek talebini g�ncelle
            UPDATE TeknikDestekTalepleri
            SET 
                PersonelID = @PersonelID,
                DurumID = @AtandiDurumID
            WHERE DestekTalepID = @DestekTalepID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
		THROW 51011, 'Atama yaparken hata olu�tu. Rollback yap�ld�', 1;
        THROW;
    END CATCH
END;