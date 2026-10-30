# Chinook Music Store SQL Analysis

Portfolio project analyzing sales and catalog data from the Chinook sample music store database with SQL.

## Main files

- [SQL analysis script](chinook_music_store_analysis.sql) — independent queries for artists, albums, tracks, genres, invoices, customers, and employees.
- [Project folder](chinook-music-store-analysis/) — includes the SQL database, organized SQL file, and detailed guide.
- [Detailed project guide](chinook-music-store-analysis/README.md) — setup, query notes, questions explored, and attribution.

## Run the queries

From the repository root, use the included database and SQL script:

```sh
sqlite3 -header -column chinook-music-store-analysis/data/Chinook_Sqlite.sqlite ".read chinook_music_store_analysis.sql"
```

The query file contains independent statements; review their result sets one at a time.

## Topics

SQL · SQL · Data Analysis · Business Questions
