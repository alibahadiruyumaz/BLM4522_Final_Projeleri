USE DB_Performans;
GO

CREATE OR ALTER PROCEDURE GetCustomerByState_Secure
    @State NVARCHAR(100)
AS
BEGIN
    -- Parametrik mimari. SQL motoru değişkeni kod olarak değil, salt metin olarak yorumlar.
    SELECT customer_id, customer_city FROM Olist_Customers WHERE customer_state = @State;
END;
GO

-- Aynı saldırı vektörünü güvenli prosedürde test et. Hata vermez ama veri de sızdırmaz.
EXEC GetCustomerByState_Secure @State = 'SP'' OR 1=1; --';
GO