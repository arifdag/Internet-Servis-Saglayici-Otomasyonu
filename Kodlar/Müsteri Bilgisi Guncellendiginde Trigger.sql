-- Müþterinin herhangi bir bilgisi deðiþtiðinde SistemLoglarýna bir log eklenir.
CREATE OR ALTER TRIGGER trg_MusteriDegisiklikLog
ON Musteriler
AFTER UPDATE
AS
BEGIN
    DECLARE @LogTipiID INT;
    
	-- Müþteri güncelleme operasyonu için doðru logTipiID'yi bul
    SELECT @LogTipiID = LogTipiID
    FROM LogTipleri lt
    JOIN LogVarlikTipleri lvt ON lt.VarlikTipiID = lvt.VarlikTipiID
    WHERE lvt.VarlikTipi = 'Musteri' 
    AND lt.IslemTipi = 'Musteri Guncellendi';

    INSERT INTO SistemLoglari (VarlikID, LogTipiID, IslemTarihi, Ayrintilar)
    SELECT 
        i.MusteriID,
        @LogTipiID,
        GETDATE(),
        'Müþteri bilgileri güncellendi: ' + 
        CASE 
            WHEN UPDATE(Ad) OR UPDATE(Soyad) 
                THEN 'Kiþisel bilgiler deðiþtirildi (Ad/Soyad)'
            WHEN UPDATE(Iletisim_ID) 
                THEN 'Ýletiþim bilgileri referansý deðiþtirildi'
            ELSE 'Diðer bilgiler deðiþtirildi'
        END
    FROM inserted i;
END;