-- Bir ödeme yapýldýðýnda ilgili faturanýn durumu 1 yani ödendi olarak güncelleni. 
-- Ardýndan log olarak SistemLoglarý tablosuna eklenir.
CREATE TRIGGER trg_OdemeKontrol 
ON Odemeler 
AFTER INSERT 
AS 
BEGIN
    BEGIN TRY
        -- Ödeme yapýldýðýnda ilgili fatura durumunu güncelle
        UPDATE f 
        SET f.Durum = 1 
        FROM Faturalar f 
        INNER JOIN inserted i ON f.AbonelikID = i.AbonelikID 
        WHERE f.FaturaTutari = i.OdemeMiktari AND f.Durum = 0;

		-- Ödeme logu için doðru logTipiID'yi bul
        DECLARE @LogTipiID INT;
        SELECT @LogTipiID = lt.LogTipiID
        FROM LogTipleri lt
        INNER JOIN LogVarlikTipleri lvt ON lt.VarlikTipiID = lvt.VarlikTipiID
        WHERE lvt.VarlikTipi = 'Odeme' 
        AND lt.IslemTipi = 'Odeme Yapildi';

        -- Ödemeyi sistem loglarýna ekle
        INSERT INTO SistemLoglari (VarlikID, LogTipiID, IslemTarihi, Ayrintilar)
        SELECT 
            i.OdemeID,
            @LogTipiID,
            GETDATE(),
            'Ödeme yapýldý ve fatura durumu güncellendi'
        FROM inserted i;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;