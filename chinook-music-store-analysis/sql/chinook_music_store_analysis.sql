-- Chinook Music Store Analysis
-- SQL dialect: SQLite
-- Queries are independent. A few missing query bodies were reconstructed from
-- question headings visible in the supplied screenshots; see the README.

-- 1. Who are the top 10 artists in terms of revenue?
SELECT
    ar.Name AS Artist,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue
FROM Artist AS ar
INNER JOIN Album AS al
    ON ar.ArtistId = al.ArtistId
INNER JOIN Track AS t
    ON al.AlbumId = t.AlbumId
INNER JOIN InvoiceLine AS il
    ON t.TrackId = il.TrackId
GROUP BY
    ar.ArtistId,
    ar.Name
ORDER BY
    Revenue DESC,
    Artist
LIMIT 10;

-- 2. Who are the top 10 artists by units sold?
SELECT
    ar.Name AS Artist,
    SUM(il.Quantity) AS Units_Sold
FROM Artist AS ar
INNER JOIN Album AS al
    ON ar.ArtistId = al.ArtistId
INNER JOIN Track AS t
    ON al.AlbumId = t.AlbumId
INNER JOIN InvoiceLine AS il
    ON t.TrackId = il.TrackId
GROUP BY
    ar.ArtistId,
    ar.Name
ORDER BY
    Units_Sold DESC,
    Artist
LIMIT 10;

-- 3. Which artists have the highest number of tracks in the catalog?
-- Reconstructed from the visible question heading; the SQL was not shown.
SELECT
    ar.Name AS Artist,
    COUNT(t.TrackId) AS Track_Count
FROM Artist AS ar
INNER JOIN Album AS al
    ON ar.ArtistId = al.ArtistId
INNER JOIN Track AS t
    ON al.AlbumId = t.AlbumId
GROUP BY
    ar.ArtistId,
    ar.Name
ORDER BY
    Track_Count DESC,
    Artist
LIMIT 10;

-- 4. Which albums generated the highest revenue?
SELECT
    ar.Name AS Artist,
    al.Title AS Album,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue
FROM Artist AS ar
INNER JOIN Album AS al
    ON ar.ArtistId = al.ArtistId
INNER JOIN Track AS t
    ON al.AlbumId = t.AlbumId
INNER JOIN InvoiceLine AS il
    ON t.TrackId = il.TrackId
GROUP BY
    ar.ArtistId,
    ar.Name,
    al.AlbumId,
    al.Title
ORDER BY
    Revenue DESC,
    Artist,
    Album
LIMIT 10;

-- 5. Which albums have the highest number of tracks sold?
SELECT
    ar.Name AS Artist,
    al.Title AS Album,
    SUM(il.Quantity) AS Units_Sold
FROM Artist AS ar
INNER JOIN Album AS al
    ON ar.ArtistId = al.ArtistId
INNER JOIN Track AS t
    ON al.AlbumId = t.AlbumId
INNER JOIN InvoiceLine AS il
    ON t.TrackId = il.TrackId
GROUP BY
    ar.ArtistId,
    ar.Name,
    al.AlbumId,
    al.Title
ORDER BY
    Units_Sold DESC,
    Artist,
    Album
LIMIT 10;

-- 6. Does an artist with more songs generate higher revenue?
SELECT
    ar.Name AS Artist,
    COUNT(DISTINCT t.TrackId) AS Track_Count,
    COALESCE(SUM(il.Quantity), 0) AS Units_Sold,
    ROUND(COALESCE(SUM(il.UnitPrice * il.Quantity), 0), 2) AS Revenue
FROM Artist AS ar
INNER JOIN Album AS al
    ON ar.ArtistId = al.ArtistId
INNER JOIN Track AS t
    ON al.AlbumId = t.AlbumId
LEFT JOIN InvoiceLine AS il
    ON t.TrackId = il.TrackId
GROUP BY
    ar.ArtistId,
    ar.Name
ORDER BY
    Revenue DESC,
    Artist;

-- 7. Which artists have tracks but no sales?
SELECT
    ar.Name AS Artist,
    COUNT(t.TrackId) AS Track_Count
FROM Artist AS ar
INNER JOIN Album AS al
    ON ar.ArtistId = al.ArtistId
INNER JOIN Track AS t
    ON al.AlbumId = t.AlbumId
LEFT JOIN InvoiceLine AS il
    ON t.TrackId = il.TrackId
GROUP BY
    ar.ArtistId,
    ar.Name
HAVING
    COUNT(il.InvoiceLineId) = 0
ORDER BY
    Track_Count DESC,
    Artist;

-- 8. Does the genre with more tracks generate higher revenue?
SELECT
    g.Name AS Genre,
    COUNT(DISTINCT t.TrackId) AS Track_Count,
    COALESCE(SUM(il.Quantity), 0) AS Units_Sold,
    ROUND(COALESCE(SUM(il.UnitPrice * il.Quantity), 0), 2) AS Revenue
FROM Genre AS g
INNER JOIN Track AS t
    ON g.GenreId = t.GenreId
LEFT JOIN InvoiceLine AS il
    ON t.TrackId = il.TrackId
GROUP BY
    g.GenreId,
    g.Name
ORDER BY
    Revenue DESC,
    Genre;

-- 9. What is the total revenue?
-- Reconstructed from the visible question heading; the SQL was not shown.
SELECT
    ROUND(SUM(UnitPrice * Quantity), 2) AS Total_Revenue
FROM InvoiceLine;

-- 10. Which invoice has the highest total?
SELECT
    InvoiceId,
    CustomerId,
    InvoiceDate,
    Total
FROM Invoice
WHERE Total = (
    SELECT MAX(Total)
    FROM Invoice
)
ORDER BY
    InvoiceId;

-- 11. Which invoice has the lowest total?
SELECT
    InvoiceId,
    CustomerId,
    InvoiceDate,
    Total
FROM Invoice
WHERE Total = (
    SELECT MIN(Total)
    FROM Invoice
)
ORDER BY
    InvoiceId;

-- 12. What is the average invoice value per customer?
SELECT
    c.CustomerId,
    c.FirstName || ' ' || c.LastName AS Customer,
    ROUND(AVG(i.Total), 2) AS Average_Invoice_Value
FROM Customer AS c
INNER JOIN Invoice AS i
    ON c.CustomerId = i.CustomerId
GROUP BY
    c.CustomerId,
    c.FirstName,
    c.LastName
ORDER BY
    Average_Invoice_Value DESC,
    Customer;

-- 13. What is the total revenue per country?
SELECT
    BillingCountry AS Country,
    ROUND(SUM(Total), 2) AS Revenue
FROM Invoice
GROUP BY
    BillingCountry
ORDER BY
    Revenue DESC,
    Country;

-- 14. What is the number of invoices per month?
SELECT
    strftime('%Y-%m', InvoiceDate) AS Month,
    COUNT(InvoiceId) AS Invoice_Count
FROM Invoice
GROUP BY
    strftime('%Y-%m', InvoiceDate)
ORDER BY
    Month;

-- 15. Which month generated the highest revenue?
SELECT
    strftime('%Y-%m', InvoiceDate) AS Month,
    ROUND(SUM(Total), 2) AS Revenue
FROM Invoice
GROUP BY
    strftime('%Y-%m', InvoiceDate)
ORDER BY
    Revenue DESC,
    Month
LIMIT 1;

-- 16. What is the average bill value per country?
SELECT
    BillingCountry AS Country,
    ROUND(AVG(Total), 2) AS Average_Invoice_Value
FROM Invoice
GROUP BY
    BillingCountry
ORDER BY
    Average_Invoice_Value DESC,
    Country;

-- 17. How many units of each track were sold?
SELECT
    t.TrackId,
    t.Name AS Track,
    COALESCE(SUM(il.Quantity), 0) AS Units_Sold
FROM Track AS t
LEFT JOIN InvoiceLine AS il
    ON t.TrackId = il.TrackId
GROUP BY
    t.TrackId,
    t.Name
ORDER BY
    Units_Sold DESC,
    Track;

-- 18. What is the total revenue per track?
-- Reconstructed from the visible question heading; the SQL was not shown.
SELECT
    t.TrackId,
    t.Name AS Track,
    ROUND(COALESCE(SUM(il.UnitPrice * il.Quantity), 0), 2) AS Revenue
FROM Track AS t
LEFT JOIN InvoiceLine AS il
    ON t.TrackId = il.TrackId
GROUP BY
    t.TrackId,
    t.Name
ORDER BY
    Revenue DESC,
    Track;

-- 19. Who is the employee serving the largest number of customers?
SELECT
    e.EmployeeId,
    e.FirstName || ' ' || e.LastName AS Employee,
    COUNT(c.CustomerId) AS Total_Customers
FROM Employee AS e
INNER JOIN Customer AS c
    ON e.EmployeeId = c.SupportRepId
GROUP BY
    e.EmployeeId,
    e.FirstName,
    e.LastName
ORDER BY
    Total_Customers DESC,
    Employee
LIMIT 1;

-- 20. Which employee generated the highest revenue from assigned customers?
SELECT
    e.EmployeeId,
    e.FirstName || ' ' || e.LastName AS Employee,
    ROUND(SUM(i.Total), 2) AS Revenue
FROM Employee AS e
INNER JOIN Customer AS c
    ON e.EmployeeId = c.SupportRepId
INNER JOIN Invoice AS i
    ON c.CustomerId = i.CustomerId
GROUP BY
    e.EmployeeId,
    e.FirstName,
    e.LastName
ORDER BY
    Revenue DESC,
    Employee
LIMIT 1;

-- 21. Which employee has the highest number of invoices?
SELECT
    e.EmployeeId,
    e.FirstName || ' ' || e.LastName AS Employee,
    COUNT(i.InvoiceId) AS Total_Invoices
FROM Employee AS e
INNER JOIN Customer AS c
    ON e.EmployeeId = c.SupportRepId
INNER JOIN Invoice AS i
    ON c.CustomerId = i.CustomerId
GROUP BY
    e.EmployeeId,
    e.FirstName,
    e.LastName
ORDER BY
    Total_Invoices DESC,
    Employee
LIMIT 1;

-- 22. How many playlists are there?
-- Reconstructed from the visible question heading; the SQL was not shown.
SELECT
    COUNT(*) AS Playlist_Count
FROM Playlist;
