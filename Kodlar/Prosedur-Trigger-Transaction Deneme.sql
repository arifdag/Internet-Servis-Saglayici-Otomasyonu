--  1 numaral� m��teri ve 3 numaral� paketi kullan�p yeni bir abonelik ve fatura olu�turur.
EXEC sp_YeniAbonelikOlustur @MusteriID =1, @PaketID = 3, @BaslangicTarihi = '2025.01.05';


-- 3 numaral� aboneli�i iptal et. Log olu�tur, faturalar� iptal et, abonelik durumunu de�i�tir, ilgili cihaz sahibini null yap.
EXEC sp_AbonelikIptal @AbonelikID = 3, @IptalNedeni = 'Yavaslik';

-- 	1 numaral� m��teri "Internet Yavas" a��klamal� bir destek talebi olu�turuyor.
EXEC sp_TeknikDestekTalebiOlustur @MusteriID = 1, @Aciklama = 'Internet Yavas';


-- 4 numaral� destek talebine 1 numaral� personeli atan�r.
EXEC sp_TeknikDestekAtama @DestekTalepID = 4, @PersonelID = 1;


-- 1 numaral� abonenin 1 numaral� �demeye y�ntemiyle faturas�n� �de. �lgili fatura durumu, �demeler tablosu, sistem loglar� g�ncellenir. (Trigger)
INSERT INTO Odemeler (AbonelikID, OdemeYontemiID, OdemeTarihi, OdemeMiktari)
VALUES (1, 1, GETDATE(), 199.99);


-- Musteri bilgisi degistigi icin log olusturur (Trigger).
UPDATE Musteriler
SET Ad = 'Yusuf'
WHERE MusteriID = 1;

-- Eger abonelik aktifse silinmesini engeller(Trigger).
DELETE FROM Abonelikler
WHERE MusteriID = 1;


-- 1 numaral� abonenin paketini 2 numaral� paketle de�i�tirir. Yeni bir log ve fatura olusturur:
EXEC sp_PaketDegistir  @AbonelikID = 1, @YeniPaketID = 2;


-- 155 numaral� personel bulunmad�g� icin yap�lan i�lemleri  geri al�r.
EXEC sp_TeknikDestekAtama @DestekTalepID = 4, @PersonelID = 155;