# Chinook Music Store SQL Analysis

A portfolio project of SQLite queries for exploring sales, customers, artists, albums, tracks, genres, and employee performance in the Chinook sample music store database.

## Project contents

- `sql/chinook_music_store_analysis.sql` — standalone analysis script with independent queries.
- `data/Chinook_Sqlite.sqlite` — sample SQLite database included in this repository.

## Dataset setup

The database is included at `data/Chinook_Sqlite.sqlite`; no separate download is needed to run the queries. To obtain the upstream release or a fresh copy, use the [Chinook database releases](https://github.com/lerocha/chinook-database/releases).

## Run the queries

The script uses SQLite syntax. You can open the database and SQL file in [DB Browser for SQLite](https://sqlitebrowser.org/) and run the statements individually to inspect each result set.

Or run the full script with the SQLite command-line tool from this directory:

```sh
sqlite3 -header -column data/Chinook_Sqlite.sqlite ".read sql/chinook_music_store_analysis.sql"
```

## Questions explored

- Top artists by revenue, units sold, and number of tracks in the catalog
- Album revenue and units sold
- Artist catalog size compared with sales and revenue
- Artists with tracks that have no sales
- Track counts, units sold, and revenue by genre
- Total store revenue and highest- and lowest-value invoices
- Average invoice value by customer and country
- Revenue by billing country
- Invoice volume and revenue by month
- Units sold and revenue by track
- Customers, revenue, and invoice counts by assigned support representative
- Number of playlists

## Query notes

- Revenue for artists, albums, genres, and tracks is calculated from invoice lines as `UnitPrice * Quantity`. Country revenue uses the invoice `Total`.
- The monthly revenue query ranks months by revenue and returns the highest-revenue month.
- The query for artists with the most catalog tracks, total revenue, revenue per track, and playlist count were reconstructed from question headings whose SQL was not fully visible in the supplied screenshots. The script marks reconstructed query sections.
- The project targets the SQLite version of Chinook; it uses SQLite's `strftime` date function and `||` string concatenation.

## License and attribution

This repository includes the Chinook sample database. It is maintained in the [upstream repository](https://github.com/lerocha/chinook-database); refer to its [license](https://github.com/lerocha/chinook-database/blob/master/LICENSE.md) for dataset attribution and use terms.
