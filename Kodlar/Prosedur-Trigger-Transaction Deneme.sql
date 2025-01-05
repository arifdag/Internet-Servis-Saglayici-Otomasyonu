--  1 numaralý müþteri ve 3 numaralý paketi kullanýp yeni bir abonelik ve fatura oluþturur.
EXEC sp_YeniAbonelikOlustur @MusteriID =1, @PaketID = 3, @BaslangicTarihi = '2025.01.05';


-- 3 numaralý aboneliði iptal et. Log oluþtur, faturalarý iptal et, abonelik durumunu deðiþtir, ilgili cihaz sahibini null yap.
EXEC sp_AbonelikIptal @AbonelikID = 3, @IptalNedeni = 'Yavaslik';

-- 	1 numaralý müþteri "Internet Yavas" açýklamalý bir destek talebi oluþturuyor.
EXEC sp_TeknikDestekTalebiOlustur @MusteriID = 1, @Aciklama = 'Internet Yavas';


-- 4 numaralý destek talebine 1 numaralý personeli atanýr.
EXEC sp_TeknikDestekAtama @DestekTalepID = 4, @PersonelID = 1;


-- 1 numaralý abonenin 1 numaralý ödemeye yöntemiyle faturasýný öde. Ýlgili fatura durumu, ödemeler tablosu, sistem loglarý güncellenir. (Trigger)
INSERT INTO Odemeler (AbonelikID, OdemeYontemiID, OdemeTarihi, OdemeMiktari)
VALUES (1, 1, GETDATE(), 199.99);


-- Musteri bilgisi degistigi icin log olusturur (Trigger).
UPDATE Musteriler
SET Ad = 'Yusuf'
WHERE MusteriID = 1;

-- Eger abonelik aktifse silinmesini engeller(Trigger).
DELETE FROM Abonelikler
WHERE MusteriID = 1;


-- 1 numaralý abonenin paketini 2 numaralý paketle deðiþtirir. Yeni bir log ve fatura olusturur:
EXEC sp_PaketDegistir  @AbonelikID = 1, @YeniPaketID = 2;


-- 155 numaralý personel bulunmadýgý icin yapýlan iþlemleri  geri alýr.
EXEC sp_TeknikDestekAtama @DestekTalepID = 4, @PersonelID = 155;