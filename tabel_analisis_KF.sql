CREATE TABLE Kf1.analisa_kimia_farma AS
SELECT 
    t.transaction_id,
    t.date,
    b.branch_id,
    b.branch_name,
    b.kota,
    b.provinsi,
    b.rating,
    c.customer_name,
    p.product_id,
    p.product_name,
    p.price,
    t.discount_percentage,
    -- Perhitungan persentase laba berdasarkan price
    CASE 
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,
    -- Perhitungan harga setelah diskon
    p.price * (1 - (t.discount_percentage / 100)) AS nett_sales,
    -- Perhitungan keuntungan yang diperoleh
    (p.price * (1 - (t.discount_percentage / 100))) * 
    CASE 
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS nett_profit,
    t.rating_transaction
FROM Kf1.kf_Final_transaction t
JOIN Kf1.kf_kantor_cabang b ON t.branch_id = b.branch_id
JOIN Kf1.kf_Final_transaction c ON t.customer_name = c.customer_name
JOIN Kf1.kf_product p ON t.product_id = p.product_id;
