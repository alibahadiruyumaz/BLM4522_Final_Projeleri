USE DB_Performans;
GO

-- 1. KRİTİK ADIM: Felaketten hemen önceki saniyeyi (temiz anı) alıyoruz.
-- Çıktıdaki bu zaman damgasını (timestamp) KESİNLİKLE bir kenara kopyala.
SELECT GETDATE() AS [Kurtarma_Icin_Hedef_Zaman];
GO

-- 2. FELAKET ANI: Dikkatsiz bir analist WHERE koşulu koymadan UPDATE yapıyor!
-- Sistemdeki binlerce siparişin durumu anında çöp veriye dönüşüyor.
UPDATE Olist_Orders 
SET order_status = 'HATALI_VERI_KAYBI';
GO

-- 3. YIKIMI DOĞRULA
SELECT TOP 10 order_id, order_status 
FROM Olist_Orders;
GO