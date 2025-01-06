-- Ýletiþim Bilgileri Tablosu:
CREATE TABLE IletisimBilgileri (
    IletisimID INT IDENTITY(1,1) PRIMARY KEY,
    Telefon NVARCHAR(15) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Il NVARCHAR(50),
    Ilce NVARCHAR(50),
    Mahalle NVARCHAR(50),
    Sokak NVARCHAR(50),
    Apartman NVARCHAR(50),
    KapiNo NVARCHAR(10)
);

-- Müþteriler Tablosu:
CREATE TABLE Musteriler (
    MusteriID INT IDENTITY(1,1) PRIMARY KEY,
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Iletisim_ID INT NOT NULL,
    KayitTarihi DATE NOT NULL,
    CONSTRAINT FK_Musteriler_Iletisim FOREIGN KEY (Iletisim_ID) REFERENCES IletisimBilgileri(IletisimID)
);

-- Paketler Tablosu:
CREATE TABLE Paketler (
    PaketID INT IDENTITY(1,1) PRIMARY KEY,
    PaketAdi NVARCHAR(100) NOT NULL,
    Hiz INT CHECK (Hiz > 0),
    Kota INT CHECK (Kota > 0),
    AylikUcret DECIMAL(10, 2) CHECK (AylikUcret > 0),
    Durum BIT NOT NULL CHECK (Durum IN (0, 1))
);

-- Abonelikler Tablosu:
CREATE TABLE Abonelikler (
    AbonelikID INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID INT NOT NULL,
    PaketID INT NOT NULL,
    BaslangicTarihi DATE NOT NULL,
    BitisTarihi DATE,
    Durum BIT NOT NULL CHECK (Durum IN (0, 1)),
    CONSTRAINT FK_Abonelikler_Musteriler FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID),
    CONSTRAINT FK_Abonelikler_Paketler FOREIGN KEY (PaketID) REFERENCES Paketler(PaketID)
);

-- Ödeme Yöntemleri Tablosu:
CREATE TABLE OdemeYontemleri (
    OdemeYontemiID INT IDENTITY(1,1) PRIMARY KEY,
    OdemeYontemiAdi NVARCHAR(50) NOT NULL UNIQUE,
	Aciklama NVARCHAR(MAX)
);

-- Ödemeler Tablosu:
CREATE TABLE Odemeler (
    OdemeID INT IDENTITY(1,1) PRIMARY KEY,
    AbonelikID INT NOT NULL,
    OdemeYontemiID INT NOT NULL,
    OdemeTarihi DATE NOT NULL,
    OdemeMiktari DECIMAL(10, 2) NOT NULL CHECK (OdemeMiktari > 0),
    CONSTRAINT UQ_Odemeler UNIQUE (AbonelikID, OdemeTarihi),
    CONSTRAINT FK_Odemeler_Abonelikler FOREIGN KEY (AbonelikID) REFERENCES Abonelikler(AbonelikID),
    CONSTRAINT FK_Odemeler_OdemeYontemleri FOREIGN KEY (OdemeYontemiID) REFERENCES OdemeYontemleri(OdemeYontemiID)
);

-- Faturalar Tablosu:
CREATE TABLE Faturalar (
    FaturaID INT IDENTITY(1,1) PRIMARY KEY,
    AbonelikID INT NOT NULL,
    FaturaTarihi DATE NOT NULL,
    SonOdemeTarihi DATE NOT NULL,
	CONSTRAINT CK_SonOdemeTarihi CHECK (SonOdemeTarihi >= FaturaTarihi),
    FaturaTutari DECIMAL(10, 2) NOT NULL CHECK (FaturaTutari > 0),
    Durum BIT NOT NULL CHECK (Durum IN (0, 1)),
    CONSTRAINT FK_Faturalar_Abonelikler FOREIGN KEY (AbonelikID) REFERENCES Abonelikler(AbonelikID)
);

-- Magazalar Tablosu:
CREATE TABLE Magazalar (
    MagazaID INT IDENTITY(1,1) PRIMARY KEY,
    MagazaAdi NVARCHAR(100) NOT NULL,
    Iletisim_ID INT NOT NULL,
    Aciklama NVARCHAR(MAX),
    CONSTRAINT FK_Magazalar_Iletisim FOREIGN KEY (Iletisim_ID) REFERENCES IletisimBilgileri(IletisimID)
);

-- Roller Tablosu:
CREATE TABLE Roller (
    RolID INT IDENTITY(1,1) PRIMARY KEY,
    RolAdi NVARCHAR(50) NOT NULL,
    Aciklama NVARCHAR(MAX)
);

-- Personel Tablosu:
CREATE TABLE Personel (
    PersonelID INT IDENTITY(1,1) PRIMARY KEY,
    MagazaID INT,
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Iletisim_ID INT NOT NULL,
    RolID INT NOT NULL,
    GorevBaslangicTarihi DATE NOT NULL,
    Maas DECIMAL(10, 2) NOT NULL CHECK (Maas > 0),
    CONSTRAINT FK_Personel_Iletisim FOREIGN KEY (Iletisim_ID) REFERENCES IletisimBilgileri(IletisimID),
    CONSTRAINT FK_Personel_Roller FOREIGN KEY (RolID) REFERENCES Roller(RolID),
    CONSTRAINT FK_Personel_Magazalar FOREIGN KEY (MagazaID) REFERENCES Magazalar(MagazaID)
);

-- Teknik Destek Durumlarý Tablosu:
CREATE TABLE TeknikDestekDurumlari (
    DestekDurumID INT IDENTITY(1,1) PRIMARY KEY,
    Durum NVARCHAR(50) NOT NULL UNIQUE,
	Aciklama NVARCHAR(MAX)
);

-- Teknik Destek Talepleri Tablosu:
CREATE TABLE TeknikDestekTalepleri (
    DestekTalepID INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID INT NOT NULL,
    PersonelID INT,
    TalepTarihi DATE NOT NULL,
    DurumID INT NOT NULL,
    Aciklama NVARCHAR(MAX),
    CozumTarihi DATE,
    CONSTRAINT FK_TeknikDestek_Musteriler FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID),
    CONSTRAINT FK_TeknikDestek_Personel FOREIGN KEY (PersonelID) REFERENCES Personel(PersonelID),
    CONSTRAINT FK_TeknikDestekDurum FOREIGN KEY (DurumID) REFERENCES TeknikDestekDurumlari(DestekDurumID)
);

-- Cihaz Tipleri Tablosu:
CREATE TABLE CihazTipleri (
    CihazTipiID INT IDENTITY(1,1) PRIMARY KEY,
    CihazTipiAdi NVARCHAR(50) NOT NULL,
    Aciklama NVARCHAR(255)
);

-- Cihaz Markalarý Tablosu
CREATE TABLE CihazMarkalari (
    MarkaID INT IDENTITY(1,1) PRIMARY KEY,
    Marka NVARCHAR(50) NOT NULL UNIQUE
);

-- Cihaz Modelleri Tablosu:
CREATE TABLE CihazModelleri (
    ModelID INT IDENTITY(1,1) PRIMARY KEY,
    MarkaID INT NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_CihazModelleri_CihazMarkalari 
        FOREIGN KEY (MarkaID) REFERENCES CihazMarkalari(MarkaID),
    CONSTRAINT UQ_CihazModel UNIQUE (MarkaID, Model)
);

-- Cihazlar Tablosu:
CREATE TABLE Cihazlar (
    CihazID INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID INT NOT NULL,
    AbonelikID INT NULL,
    CihazTipiID INT NULL,
    ModelID INT NULL,
    SeriNumarasi NVARCHAR(50) NOT NULL UNIQUE,
    VerilisTarihi DATE NOT NULL,
    Durum BIT NOT NULL CHECK (Durum IN (0, 1)),
    CONSTRAINT FK_Cihazlar_Musteriler FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID),
    CONSTRAINT FK_Cihazlar_Abonelikler FOREIGN KEY (AbonelikID) REFERENCES Abonelikler(AbonelikID),
    CONSTRAINT FK_Cihazlar_CihazTipi FOREIGN KEY (CihazTipiID) REFERENCES CihazTipleri(CihazTipiID),
    CONSTRAINT FK_Cihazlar_CihazModel FOREIGN KEY (ModelID) REFERENCES CihazModelleri(ModelID)
);

-- Kampanyalar Tablosu:
CREATE TABLE Kampanyalar (
    KampanyaID INT IDENTITY(1,1) PRIMARY KEY,
    KampanyaAdi NVARCHAR(100) NOT NULL,
    BaslangicTarihi DATE NOT NULL,
    BitisTarihi DATE NOT NULL,
	CONSTRAINT CK_Kampanya_Bitis_Tarihi CHECK (BitisTarihi >= BaslangicTarihi),
    IndirimOrani DECIMAL(5, 2) NOT NULL CHECK (IndirimOrani >= 0 AND IndirimOrani <= 100),
    Aciklama NVARCHAR(MAX)
);

-- Kampanya Paketleri Tablosu:
CREATE TABLE KampanyaPaketleri (
    KampanyaPaketID INT IDENTITY(1,1) PRIMARY KEY,
    KampanyaID INT NOT NULL,
    PaketID INT NOT NULL,
    EkAciklama NVARCHAR(255),
    CONSTRAINT FK_KampanyaPaketleri_Kampanyalar FOREIGN KEY (KampanyaID) REFERENCES Kampanyalar(KampanyaID),
    CONSTRAINT FK_KampanyaPaketleri_Paketler FOREIGN KEY (PaketID) REFERENCES Paketler(PaketID)
);

-- Log Varlýk Tipleri Tablosu:
CREATE TABLE LogVarlikTipleri (
    VarlikTipiID INT IDENTITY(1,1) PRIMARY KEY,
    VarlikTipi NVARCHAR(50) NOT NULL UNIQUE,
    Aciklama NVARCHAR(MAX)
);

-- Log Tipleri Tablosu:
CREATE TABLE LogTipleri (
    LogTipiID INT IDENTITY(1,1) PRIMARY KEY,
    IslemTipi NVARCHAR(50) NOT NULL,
    VarlikTipiID INT NOT NULL,
    CONSTRAINT FK_LogTipleri_VarlikTipleri FOREIGN KEY (VarlikTipiID) REFERENCES LogVarlikTipleri(VarlikTipiID)
);

-- Sistem Loglarý Tablosu:
CREATE TABLE SistemLoglari (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    VarlikID INT NOT NULL,
    LogTipiID INT NOT NULL,
    IslemTarihi DATETIME NOT NULL,
    Ayrintilar NVARCHAR(MAX),
    CONSTRAINT FK_SistemLoglari_LogTipleri FOREIGN KEY (LogTipiID) REFERENCES LogTipleri(LogTipiID)
);

-- Bakim Tipleri Tablosu:
CREATE TABLE BakimTipleri (
    BakimTipiID INT IDENTITY(1,1) PRIMARY KEY,
    BakimTipiAdi NVARCHAR(50) NOT NULL,
    Aciklama NVARCHAR(MAX)
);

-- Bakým Durumlarý Tablosu:
CREATE TABLE BakimDurumlari (
    DurumID INT IDENTITY(1,1) PRIMARY KEY,
    DurumAdi NVARCHAR(50) NOT NULL UNIQUE,
	Aciklama NVARCHAR(MAX)
);

-- Bakým Kayýtlarý Tablosu:
CREATE TABLE BakimKayitlari (
    BakimID INT IDENTITY(1,1) PRIMARY KEY,
    PersonelID INT NOT NULL,
    BakimTipiID INT NOT NULL,
    BakimTarihi DATE NOT NULL,
    Aciklama NVARCHAR(255),
    DurumID INT NOT NULL,
    CONSTRAINT FK_BakimKayitlari_Personel FOREIGN KEY (PersonelID) REFERENCES Personel(PersonelID),
    CONSTRAINT FK_BakimKayitlari_BakimTipleri FOREIGN KEY (BakimTipiID) REFERENCES BakimTipleri(BakimTipiID),
    CONSTRAINT FK_BakimKayitlari_Durum FOREIGN KEY (DurumID) REFERENCES BakimDurumlari(DurumID)
);
