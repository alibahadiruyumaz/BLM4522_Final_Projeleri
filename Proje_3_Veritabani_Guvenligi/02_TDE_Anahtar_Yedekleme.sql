USE master;
GO

-- Dosyaların zaten var olup olmadığını kontrol et
DECLARE @MasterKeyVar INT, @CertVar INT, @PrivKeyVar INT;

EXEC master.dbo.xp_fileexist 'C:\SQL_Keys\MasterKey.bak',        @MasterKeyVar OUTPUT;
EXEC master.dbo.xp_fileexist 'C:\SQL_Keys\TDE_Olist_Cert.cer',   @CertVar OUTPUT;
EXEC master.dbo.xp_fileexist 'C:\SQL_Keys\TDE_Olist_Cert_PrivateKey.pvk', @PrivKeyVar OUTPUT;

-- Master Key yedekle (dosya yoksa)
IF @MasterKeyVar = 0
BEGIN
    BACKUP MASTER KEY 
    TO FILE = 'C:\SQL_Keys\MasterKey.bak'
    ENCRYPTION BY PASSWORD = 'Yedek_Icin_Karmasik_Sifre_456!';
    PRINT 'Master Key yedeklendi.';
END
ELSE
    PRINT 'Master Key yedeği zaten mevcut, atlandı.';
GO

-- Sertifika ve Private Key yedekle (dosyalar yoksa)
DECLARE @CertVar2 INT, @PrivKeyVar2 INT;

EXEC master.dbo.xp_fileexist 'C:\SQL_Keys\TDE_Olist_Cert.cer',   @CertVar2 OUTPUT;
EXEC master.dbo.xp_fileexist 'C:\SQL_Keys\TDE_Olist_Cert_PrivateKey.pvk', @PrivKeyVar2 OUTPUT;

IF @CertVar2 = 0 AND @PrivKeyVar2 = 0
BEGIN
    BACKUP CERTIFICATE TDE_Olist_Cert
    TO FILE = 'C:\SQL_Keys\TDE_Olist_Cert.cer'
    WITH PRIVATE KEY (
        FILE = 'C:\SQL_Keys\TDE_Olist_Cert_PrivateKey.pvk',
        ENCRYPTION BY PASSWORD = 'Yedek_Icin_Karmasik_Sifre_456!'
    );
    PRINT 'Sertifika ve Private Key yedeklendi.';
END
ELSE
    PRINT 'Sertifika yedeği zaten mevcut, atlandı.';
GO