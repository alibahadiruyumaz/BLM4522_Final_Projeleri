USE DB_Performans;
GO

-- Kurumsal Yedekleme Otomasyon Motoru
CREATE OR ALTER PROCEDURE sp_OtomatikYedekleme
    @YedekTipi NVARCHAR(10) -- 'FULL', 'DIFF' veya 'LOG' parametrelerini alır
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @KlasorYolu NVARCHAR(200) = 'C:\SQL_Backups\';
    DECLARE @DosyaAdi NVARCHAR(255);
    DECLARE @TarihDamgasi NVARCHAR(20);
    DECLARE @SQLKomutu NVARCHAR(MAX);
    
    -- Dosyaların çakışmasını engellemek için saniye hassasiyetinde dinamik zaman damgası (Örn: 20260513_183045)
    SET @TarihDamgasi = FORMAT(GETDATE(), 'yyyyMMdd_HHmmss');
    
    -- Gelen parametreye göre SQL komutunu dinamik olarak inşa et
    IF @YedekTipi = 'FULL'
    BEGIN
        SET @DosyaAdi = @KlasorYolu + 'DB_Performans_FULL_' + @TarihDamgasi + '.bak';
        SET @SQLKomutu = 'BACKUP DATABASE DB_Performans TO DISK = ''' + @DosyaAdi + ''' WITH FORMAT, INIT, STATS = 10;';
    END
    ELSE IF @YedekTipi = 'DIFF'
    BEGIN
        SET @DosyaAdi = @KlasorYolu + 'DB_Performans_DIFF_' + @TarihDamgasi + '.bak';
        SET @SQLKomutu = 'BACKUP DATABASE DB_Performans TO DISK = ''' + @DosyaAdi + ''' WITH DIFFERENTIAL, INIT, STATS = 10;';
    END
    ELSE IF @YedekTipi = 'LOG'
    BEGIN
        SET @DosyaAdi = @KlasorYolu + 'DB_Performans_LOG_' + @TarihDamgasi + '.trn';
        SET @SQLKomutu = 'BACKUP LOG DB_Performans TO DISK = ''' + @DosyaAdi + ''' WITH INIT, STATS = 10;';
    END
    ELSE
    BEGIN
        PRINT 'HATA: Gecersiz Yedek Tipi! Sadece FULL, DIFF veya LOG kullanilabilir.';
        RETURN;
    END

    -- İnşa edilen dinamik komutu çalıştır
    PRINT 'Yedekleme Baslatiliyor: ' + @DosyaAdi;
    EXEC sp_executesql @SQLKomutu;
    PRINT 'Yedekleme Basariyla Tamamlandi.';
END;
GO

-- SİSTEM TESTİ: Motoru FULL ve LOG parametreleriyle test edelim
EXEC sp_OtomatikYedekleme @YedekTipi = 'FULL';
EXEC sp_OtomatikYedekleme @YedekTipi = 'LOG';
GO