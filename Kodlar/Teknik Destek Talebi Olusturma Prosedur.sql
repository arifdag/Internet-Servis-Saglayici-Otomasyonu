-- Verilen MusteriID’yi ve Aciklama’yý kullanarak yeni bir destek talebi oluþturur. 
-- Bu iþlem sýrasýnda bir hata oluþursa yapýlan bütün iþlemler geri alýnýr.
CREATE PROCEDURE sp_TeknikDestekTalebiOlustur
    @MusteriID INT,
    @Aciklama NVARCHAR(MAX)
AS
BEGIN
    DECLARE @YeniTalepDurumID INT;

    BEGIN TRY
        -- "Yeni" durumu için DestekDurumID'yi bul
        SELECT @YeniTalepDurumID = DestekDurumID 
        FROM TeknikDestekDurumlari 
        WHERE Durum = 'Yeni';

		-- Eðer öyle bi durum yoksa hata ver
        IF @YeniTalepDurumID IS NULL
        BEGIN
            THROW 51007, 'Sistem hatasý: "Yeni" durum tanýmý bulunamadý.', 1;
        END

        BEGIN TRANSACTION;
            -- Müþterinin varlýðýný ve aktif bir aboneliðinin olup olmadýðýný kontrol et.
            IF NOT EXISTS (
                SELECT 1 
                FROM Musteriler m
                JOIN Abonelikler a ON m.MusteriID = a.MusteriID
                WHERE m.MusteriID = @MusteriID AND a.Durum = 1
            )
            BEGIN
                THROW 51003, 'Müþteri bulunamadý veya aktif aboneliði yok.', 1;
            END

            -- Destek talebi oluþtur.
            INSERT INTO TeknikDestekTalepleri (
                MusteriID, 
                TalepTarihi, 
                DurumID, 
                Aciklama
            )
            VALUES (
                @MusteriID, 
                GETDATE(), 
                @YeniTalepDurumID, 
                @Aciklama
            );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
            ROLLBACK TRANSACTION;
			 THROW 51004, 'Hata oluþtu, iþlemler geri alýndý', 1;
        THROW;
    END CATCH
END;
