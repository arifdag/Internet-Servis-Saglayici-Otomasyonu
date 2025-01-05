-- Verilen MusteriID�yi ve Aciklama�y� kullanarak yeni bir destek talebi olu�turur. 
-- Bu i�lem s�ras�nda bir hata olu�ursa yap�lan b�t�n i�lemler geri al�n�r.
CREATE PROCEDURE sp_TeknikDestekTalebiOlustur
    @MusteriID INT,
    @Aciklama NVARCHAR(MAX)
AS
BEGIN
    DECLARE @YeniTalepDurumID INT;

    BEGIN TRY
        -- "Yeni" durumu i�in DestekDurumID'yi bul
        SELECT @YeniTalepDurumID = DestekDurumID 
        FROM TeknikDestekDurumlari 
        WHERE Durum = 'Yeni';

		-- E�er �yle bi durum yoksa hata ver
        IF @YeniTalepDurumID IS NULL
        BEGIN
            THROW 51007, 'Sistem hatas�: "Yeni" durum tan�m� bulunamad�.', 1;
        END

        BEGIN TRANSACTION;
            -- M��terinin varl���n� ve aktif bir aboneli�inin olup olmad���n� kontrol et.
            IF NOT EXISTS (
                SELECT 1 
                FROM Musteriler m
                JOIN Abonelikler a ON m.MusteriID = a.MusteriID
                WHERE m.MusteriID = @MusteriID AND a.Durum = 1
            )
            BEGIN
                THROW 51003, 'M��teri bulunamad� veya aktif aboneli�i yok.', 1;
            END

            -- Destek talebi olu�tur.
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
			 THROW 51004, 'Hata olu�tu, i�lemler geri al�nd�', 1;
        THROW;
    END CATCH
END;
