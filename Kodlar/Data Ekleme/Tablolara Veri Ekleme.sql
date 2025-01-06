-- �leti�im Bilgileri Tablosuna Veri Ekleme:
INSERT INTO IletisimBilgileri (Telefon, Email, Il, Ilce, Mahalle, Sokak, Apartman, KapiNo)
VALUES 
('5443692485', 'halilibro921@gmail.com', 'Denizli', 'Pamukkale', 'Beyaz�t', 'Kelmahmut', 'Portakal', '1'),
('5436965848', 'cagri_soysal34@hotmail.com', 'Istanbul', 'Sisli', 'Mecidiyekoy', 'Buyukdere', 'Plaza', '10'),
('5593486922', 'yusufAyd�n@proton.me', 'Kayseri', 'Melikgazi', 'Aliler', 'Mustafa Kemal Pasa', 'Remax', '19'),
('5423691599', 'salim.teknik1@iss.com', 'Istanbul', 'Kadikoy', 'Caferaga', 'karabagci', 'Balci', '14'),
 ('5448396502', 'kemal.saha1@iss.com', 'Istanbul', 'Besiktas', 'Levent', 'karasalci', 'Salci', '22'),
 ('5503698751', 'melekyorden@proton.me', 'Istanbul', 'Bagcilar', 'Mecidiyekoy', 'cemisgezek', 'Remax', '9'),
 ('5414141254', 'esrabagli@gmail.com', 'Istanbul', 'Uskudar', 'Altunizade', 'shibuya', 'Elysium', '1');


-- Musteriler Tablosuna Veri Ekleme:
INSERT INTO Musteriler (Ad, Soyad, Iletisim_ID, KayitTarihi)
VALUES 
('Halil Ibrahim', 'Yilmaz', 1, '2024-01-04'),
('Cagri', 'Soysal', 2, '2024-01-03');


-- Paketler Tablosuna Veri Ekleme:
INSERT INTO Paketler (PaketAdi, Hiz, Kota, AylikUcret, Durum)
VALUES 
('Fiber 50Mbps', 50, 100, 199.99, 1),
('Fiber 100Mbps', 100, 250, 299.99, 1),
('Fiber Ultra', 200, 1000, 499.99, 1);


-- LogVarl�kTipleri Tablosuna Veri Ekleme:
INSERT INTO LogVarlikTipleri (VarlikTipi, Aciklama)
VALUES 
('Odeme', '�deme i�lemleri ile ilgili loglar'),
('Abonelik', 'Abonelik i�lemleri ile ilgili loglar'),
('Musteri', 'M��teri i�lemleri ile ilgili loglar');


-- LogTipleri Tablosuna Veri Ekleme:
INSERT INTO LogTipleri (IslemTipi, VarlikTipiID)
VALUES
('Odeme Yapildi', (SELECT VarlikTipiID FROM LogVarlikTipleri WHERE VarlikTipi = 'Odeme')),      
('Odeme Iptal', (SELECT VarlikTipiID FROM LogVarlikTipleri WHERE VarlikTipi = 'Odeme')),
('Abonelik Basladi', (SELECT VarlikTipiID FROM LogVarlikTipleri WHERE VarlikTipi = 'Abonelik')),
('Abonelik Sonlandi', (SELECT VarlikTipiID FROM LogVarlikTipleri WHERE VarlikTipi = 'Abonelik')), 
('Musteri Eklendi', (SELECT VarlikTipiID FROM LogVarlikTipleri WHERE VarlikTipi = 'Musteri')),
('Musteri Guncellendi', (SELECT VarlikTipiID FROM LogVarlikTipleri WHERE VarlikTipi = 'Musteri')),
('Musteri Silindi', (SELECT VarlikTipiID FROM LogVarlikTipleri WHERE VarlikTipi = 'Musteri')),
('Paket Degistirildi', (SELECT VarlikTipiID FROM LogVarlikTipleri WHERE VarlikTipi = 'Abonelik'));


-- OdemeYontemleri Tablosuna Veri Ekleme:
INSERT INTO OdemeYontemleri (OdemeYontemiAdi, Aciklama)
VALUES 
    ('Kredi Kart�', 'Kredi kartlar� ile yap�lan �demeler.'),
    ('Banka Havalesi', 'Banka hesab� �zerinden yap�lan para transferi ile �deme.'),
    ('Mobil �deme', 'Cep telefonu numaras� �zerinden yap�lan �deme i�lemleri.');


-- TeknikDestekDurumlar� Tablosuna Veri Ekleme:
INSERT INTO TeknikDestekDurumlari (Durum, Aciklama)
VALUES 
    ('Yeni', 'Hen�z i�leme al�nmam�� yeni destek talebi'),
    ('Beklemede', 'De�erlendirme a�amas�nda olan talepler'),
    ('Atand�', 'Teknik personele atanm��, ��z�m s�recinde'),
    ('M��teri Yan�t� Bekleniyor', 'M��teriden ek bilgi veya onay bekleniyor'),
    ('Sahada', 'Teknik ekip m��teri lokasyonunda'),
    ('Test A�amas�nda', '��z�m uyguland�, test ediliyor'),
    ('��z�ld�', 'Teknik destek talebi ��z�me ula�t�'),
    ('Kapal�', 'Talep sonland�r�ld� ve ar�ivlendi'),
    ('�ptal Edildi', 'M��teri talebi ile iptal edildi'),
    ('Tekrar A��ld�', '��z�len talep tekrar a��ld�');


-- Roller Tablosuna Veri Ekleme:
INSERT INTO Roller (RolAdi, Aciklama)
VALUES 
    ('Teknik Destek Uzman�', 'M��teri teknik sorunlar�n� ��zen personel'),
    ('Teknik Ekip Lideri', 'Teknik ekibi y�neten ve koordine eden personel'),
    ('Saha Teknisyeni', 'Saha kurulum ve onar�m i�lerini yapan personel'),
    ('Network Uzman�', 'A� altyap�s� ve optimizasyonundan sorumlu personel'),
    ('Magaza Musteri Danismani', 'Magazada musterilerle ilgilenen personel'),
    ('Magaza Muduru', 'Magaza yonetiminden sorumlu personel');


-- Magazalar Tablosuna Veri Ekleme:
INSERT INTO Magazalar (MagazaAdi, Iletisim_ID, Aciklama)
VALUES ('Kad�k�y Teknik Merkez', 
    (SELECT IletisimID FROM IletisimBilgileri WHERE Email = 'salim.teknik1@iss.com'),
    'Ana teknik destek merkezi');


-- Personel Tablosuna Veri Ekleme:
INSERT INTO Personel (MagazaID, Ad, Soyad, Iletisim_ID, RolID, GorevBaslangicTarihi, Maas)
SELECT 
    (SELECT TOP 1 MagazaID FROM Magazalar), 
    Ad,
    Soyad,
    IletisimID,
    RolID,
    '2024-01-05',
    Maas
FROM (
    VALUES 
        ('Salim', 'Berke', 
         (SELECT IletisimID FROM IletisimBilgileri WHERE Email = 'salim.teknik1@iss.com'),
         (SELECT RolID FROM Roller WHERE RolAdi = 'Teknik Destek Uzman�'),
         8500.00),
        ('Kemal', 'Yonca',
         (SELECT IletisimID FROM IletisimBilgileri WHERE Email = 'kemal.saha1@iss.com'),
         (SELECT RolID FROM Roller WHERE RolAdi = 'Saha Teknisyeni'),
         7500.00),
        ('Melek', 'Yorden',
         (SELECT IletisimID FROM IletisimBilgileri WHERE Email = 'melekyorden@proton.me'),
         (SELECT RolID FROM Roller WHERE RolAdi = 'Magaza Musteri Danismani'),
         6000.00),
        ('Esra', 'Bagli',
         (SELECT IletisimID FROM IletisimBilgileri WHERE Email = 'esrabagli@gmail.com'),
         (SELECT RolID FROM Roller WHERE RolAdi = 'Magaza Muduru'),
         10000.00)
) AS PersonelVeri(Ad, Soyad, IletisimID, RolID, Maas);


--Abonelikler Tablosuna Veri Ekleme:
INSERT INTO Abonelikler (MusteriID, PaketID, BaslangicTarihi, BitisTarihi, Durum)
VALUES 
(1, 1, '2024-01-04', NULL, 1),
(2, 2, '2024-01-03', NULL, 1);


-- Faturalar Tablosuna Veri Ekleme:
INSERT INTO Faturalar (AbonelikID, FaturaTarihi, SonOdemeTarihi, FaturaTutari, Durum)
VALUES 
(1, '2024-01-04', '2024-02-04', 199.99, 0),  
(2, '2024-01-03', '2024-02-03', 299.99, 1);   


-- Odemeler Tablosuna Veri Ekleme:
INSERT INTO Odemeler (AbonelikID, OdemeYontemiID, OdemeTarihi, OdemeMiktari)
VALUES 
(2, 1, '2024-01-03', 299.99),
(1, 2, '2024-01-15', 199.99); 

-- TeknikDestekTalepleri Tablosuna Veri Ekleme:
INSERT INTO TeknikDestekTalepleri (MusteriID, PersonelID, TalepTarihi, DurumID, Aciklama, CozumTarihi)
VALUES 
(1, 1, '2024-01-05', 1, '�nternet ba�lant�s� kesiliyor', NULL),
(2, 2, '2024-01-06', 3, 'Modem ar�zas�', NULL),
(1, 3, '2024-01-07', 7, 'Yava� internet sorunu', '2024-01-07');


-- SistemLoglari Tablosuna Veri Ekleme:
INSERT INTO SistemLoglari (VarlikID, LogTipiID, IslemTarihi, Ayrintilar)
VALUES 
(1, 1, '2024-01-05 10:30:00', 'Yeni abonelik ba�lat�ld�'),
(2, 3, '2024-01-05 11:45:00', '�deme al�nd�'),
(1, 5, '2024-01-06 09:15:00', 'M��teri bilgileri g�ncellendi');


-- CihazTipleri Tablosuna Veri Ekleme:
INSERT INTO CihazTipleri (CihazTipiAdi, Aciklama)
VALUES 
('Modem', 'Internet ba�lant�s� i�in modem cihaz�'),
('Router', 'Kablosuz a� y�nlendiricisi');


-- CihazMarkalar� Tablosuna Veri Ekleme:
INSERT INTO CihazMarkalari (Marka)
VALUES 
('TP-Link'),
('Huawei'),
('Zyxel'),
('Asus');


-- CihazModelleri Tablosuna Veri Ekleme:
INSERT INTO CihazModelleri (MarkaID, Model)
VALUES 
(1, 'Archer VR300'),
(2, 'HG658 V2'),
(3, 'VMG1312-T20B'),
(4, 'DSL-AX82U');


-- Cihazlar Tablosuna Veri Ekleme:
INSERT INTO Cihazlar (MusteriID, AbonelikID, CihazTipiID, ModelID, SeriNumarasi, VerilisTarihi, Durum)
VALUES 
(2, 2, 1, 3, 'SN982564762145', '2024-01-05', 1);


-- Kampanyalar Tablosuna Veri Ekleme:
INSERT INTO Kampanyalar (KampanyaAdi, BaslangicTarihi, BitisTarihi, IndirimOrani, Aciklama)
VALUES 
('Yeni Y�l Kampanyas�', '2024-01-01', '2024-02-01', 25.00, '2025 y�l�na �zel indirim kampanyas�'),
('��renci Kampanyas�', '2024-02-24', '2024-06-30', 30.00, '��rencilere �zel indirim'),
('Yaz F�rsat�', '2024-06-01', '2024-08-31', 20.00, 'Yaz aylar�na �zel indirim kampanyas�');


-- Kampanya Paketleri Tablosuna Veri Ekleme:
INSERT INTO KampanyaPaketleri (KampanyaID, PaketID, EkAciklama)
VALUES 
(1, 1, 'Fiber 50Mbps paketi i�in ge�erli'),
(1, 2, 'Fiber 100Mbps paketi i�in ge�erli'),
(2, 1, '��renciler i�in uygun paket'),
(3, 3, 'Ultra paket yaz indirimi');


-- Bak�mTipleri Tablosuna Veri Ekleme:
INSERT INTO BakimTipleri (BakimTipiAdi, Aciklama)
VALUES 
('Rutin Kontrol', 'Periyodik rutin altyap� kontrolleri'),
('Ar�za Giderme', 'Ar�za durumunda yap�lan bak�m'),
('G�ncelleme', 'Sistem g�ncellemeleri ve y�kseltmeleri');


-- Bak�mDurumlar� Tablosuna Veri Ekleme:
INSERT INTO BakimDurumlari (DurumAdi, Aciklama)
VALUES 
('Planland�', 'Bak�m i�lemi planland�, hen�z ba�lamad�'),
('Devam Ediyor', 'Bak�m i�lemi devam ediyor'),
('Tamamland�', 'Bak�m i�lemi ba�ar�yla tamamland�'),
('�ptal Edildi', 'Bak�m i�lemi iptal edildi');


-- Bak�mKay�tlar� Tablosuna Veri Ekleme:
INSERT INTO BakimKayitlari (PersonelID, BakimTipiID, BakimTarihi, Aciklama, DurumID)
VALUES 
(1, 1, '2024-01-05', 'Periyodik rutin bak�m yap�ld�', 3),
(2, 2, '2024-01-05', 'Fiber kablo ar�zas� giderildi', 3),
(1, 3, '2024-01-06', 'Sistem g�ncellemesi yap�lacak', 1);
