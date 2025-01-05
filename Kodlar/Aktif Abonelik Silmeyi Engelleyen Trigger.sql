-- Aktif durumda olan bir aboneli�i silmeyi engeller.
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
        THROW 51008, 'Aktif olan bir abonelik silinemez. L�tfen �nce deaktive edin.', 1;
        RETURN;
    END
    
    DELETE a
    FROM Abonelikler a
    INNER JOIN deleted d ON a.AbonelikID = d.AbonelikID;
END;