-- Bir �deme yap�ld���nda ilgili faturan�n durumu 1 yani �dendi olarak g�ncelleni. 
-- Ard�ndan log olarak SistemLoglar� tablosuna eklenir.
CREATE TRIGGER trg_OdemeKontrol 
ON Odemeler 
AFTER INSERT 
AS 
BEGIN
    BEGIN TRY
        -- �deme yap�ld���nda ilgili fatura durumunu g�ncelle
        UPDATE f 
        SET f.Durum = 1 
        FROM Faturalar f 
        INNER JOIN inserted i ON f.AbonelikID = i.AbonelikID 
        WHERE f.FaturaTutari = i.OdemeMiktari AND f.Durum = 0;

		-- �deme logu i�in do�ru logTipiID'yi bul
        DECLARE @LogTipiID INT;
        SELECT @LogTipiID = lt.LogTipiID
        FROM LogTipleri lt
        INNER JOIN LogVarlikTipleri lvt ON lt.VarlikTipiID = lvt.VarlikTipiID
        WHERE lvt.VarlikTipi = 'Odeme' 
        AND lt.IslemTipi = 'Odeme Yapildi';

        -- �demeyi sistem loglar�na ekle
        INSERT INTO SistemLoglari (VarlikID, LogTipiID, IslemTarihi, Ayrintilar)
        SELECT 
            i.OdemeID,
            @LogTipiID,
            GETDATE(),
            '�deme yap�ld� ve fatura durumu g�ncellendi'
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;