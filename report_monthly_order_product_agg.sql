-- Membuat tabel sementara --
CREATE TEMPORARY TABLE report_monthly_orders_product_agg AS
SELECT
--Mengekstrak tahun dari kolom created_at dengan tabel order_items (oi) untuk mendapatkan tahun penjualan --
    EXTRACT(YEAR FROM oi.created_at) AS YEAR,
-- Mengekstrak tahun dari kolom created_at dengan tabel order_items (oi) untuk mendapatkan tahun penjualan --
    EXTRACT(MONTH FROM oi.created_at) AS MONTH,
-- Mengambil ID produk dari tabel order_items --
    oi.product_id,
-- Mengambil nama produk dari tabel order_items --
    p.name,
--  Menghitung total qty produk yang terjual dalam satu bulan, untuk setiap produk -- 
    SUM(o.num_of_item) AS total_quantity_sold,
-- Menghitung total pendapatan dari penjualan produk dalam satu bulan --
    SUM(o.num_of_item * oi.sale_price) AS total_sales_amount
-- Bagian ini mengambil data dari tabel order_items --
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` oi
-- Melakukan join antara tabel order_items (oi) dan tabel products (p) menggunakan kolom product_id --
JOIN
    `bigquery-public-data.thelook_ecommerce.products` p
ON
    oi.product_id = p.id
-- Melakukan join antara tabel order_items (oi) dan tabel orders (o) menggunakan kolom order_id --
JOIN
    `bigquery-public-data.thelook_ecommerce.orders` o
ON
    oi.order_id = o.order_id  
-- Mengelompokkan hasil query berdasarkan tahun (year), bulan (month), ID produk (product_id), dan nama produk (name) --
GROUP BY
    YEAR, MONTH, oi.product_id, p.name
-- Mengurutkan hasil query berdasarkan tahun, bulan, dan total pendapatan dari penjualan (total_sales_amount) dari yang terbesar ke yang terkecil. --
ORDER BY
    YEAR, MONTH, total_sales_amount DESC;
