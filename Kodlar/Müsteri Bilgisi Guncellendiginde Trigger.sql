-- M��terinin herhangi bir bilgisi de�i�ti�inde SistemLoglar�na bir log eklenir.
CREATE OR ALTER TRIGGER trg_MusteriDegisiklikLog
ON Musteriler
AFTER UPDATE
AS
BEGIN
    DECLARE @LogTipiID INT;
    
	-- M��teri g�ncelleme operasyonu i�in do�ru logTipiID'yi bul
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
        'M��teri bilgileri g�ncellendi: ' + 
        CASE 
            WHEN UPDATE(Ad) OR UPDATE(Soyad) 
                THEN 'Ki�isel bilgiler de�i�tirildi (Ad/Soyad)'
            WHEN UPDATE(Iletisim_ID) 
                THEN '�leti�im bilgileri referans� de�i�tirildi'
            ELSE 'Di�er bilgiler de�i�tirildi'
        END
    FROM inserted i;
END;