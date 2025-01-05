-- Aktif durumda olan bir aboneliði silmeyi engeller.
CREATE TRIGGER trg_AktifAbonelikSilmeEngelleme
ON Abonelikler
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM deleted 
        WHERE Durum = 1
    )
    BEGIN
        THROW 51008, 'Aktif olan bir abonelik silinemez. Lütfen önce deaktive edin.', 1;
        RETURN;
    END
    
    DELETE a
    FROM Abonelikler a
    INNER JOIN deleted d ON a.AbonelikID = d.AbonelikID;
END;