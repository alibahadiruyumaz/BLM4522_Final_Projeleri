USE master;
GO

-- Master Key'in yedeklenmesi
BACKUP MASTER KEY 
TO FILE = 'C:\SQL_Keys\MasterKey.bak'
ENCRYPTION BY PASSWORD = 'Yedek_Icin_Karmasik_Sifre_456!';
GO

-- Sertifikanın ve Private Key'in (Özel Anahtar) yedeklenmesi
BACKUP CERTIFICATE TDE_Olist_Cert
TO FILE = 'C:\SQL_Keys\TDE_Olist_Cert.cer'
WITH PRIVATE KEY (
    FILE = 'C:\SQL_Keys\TDE_Olist_Cert_PrivateKey.pvk',
    ENCRYPTION BY PASSWORD = 'Yedek_Icin_Karmasik_Sifre_456!'
);
GO