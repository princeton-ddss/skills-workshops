# Legacy DDSS Workshop Materials

Four workshop series from Data-Driven Social Science (DDSS), most recent
edition of each. Folders are named `<series>_<session#>_<topic>`.

Decks are self-contained HTML (xaringan — open in any browser, no build step).
Where a `.Rmd` is present it is the source used to regenerate the deck.

## Large data processing with SQL for social science
Fall 2025. DuckDB-centred. Sources included.

| Folder | Session | Deck | Source | Code-along |
|---|---|---|---|---|
| `sql_01_intro_to_sql_duckdb/` | I: Intro to SQL (via DuckDB) | `session1.html` (Oct 27 2025) | `session1.Rmd` | `code_along_1.sql`, `code_along_2.sql` |
| `sql_02_large_data_in_sql/` | II: Working with large data in SQL | `session2_25.html` (Nov 3 2025) | `session2_25.Rmd` | `code_along_1.R`, `code_along_2.R`, `bonus_answer.R` |
| `sql_03_sql_and_r_workflows/` | III: More workflows in SQL and R | `session3.html` (Nov 10 2025) | `session3.Rmd` | — |

Data was pulled before handoff. The scripts expect a `data/` subfolder; the
paths in the code-along files show what to re-download (NC voter registration
snapshots, MIT county presidential returns, Census county shapefiles, NYC taxi
parquet).

## Record Linkage
Spring 2025, with the session-II demo rewritten Feb 2026. Sources included.

| Folder | Session | Deck | Source | Demo / data |
|---|---|---|---|---|
| `record_linkage_01_deterministic/` | I: Overview and deterministic linkage | `rl1.html` (Mar 24 2025) | `rl1.Rmd` | — |
| `record_linkage_02_probabilistic/` | II: Probabilistic record linkage | `rl2.html` (Mar 31 2025) | `rl2.Rmd` | `demo.ipynb` + `demo.db`, `demo_model.json` (Splink, Feb 2026) |
| `record_linkage_03_lsh_fuzzy_joins/` | III: LSH / fuzzy string joins | **no deck** | — | `zoomer.R` + `nc_first.rda`, `address_ex.json`, `ex_place.json` |

- `demo.ipynb` is the Feb 2026 rewrite and is self-contained: it reads only
  `demo.db` and `demo_model.json`. The earlier edition's large FEC parquet
  extracts are no longer needed.
- Session III has materials but **no slide deck** — `zoomer.R` demos
  `zoomerjoin` (Jaccard LSH, banding, hyper-grid search) on NC first names.
  `lsh_notes.pdf` in this directory is the companion theory for it.

## Larger-than-Memory Data without HPC
Fall 2023. The only edition. **Decks only — no `.Rmd` sources were kept**, so
these can be presented but not regenerated. Topically adjacent to the SQL
series but covers different tooling, so retained as its own workshop.

| Folder | Session | Deck | Covers |
|---|---|---|---|
| `larger_than_memory_01_arrow/` | I | `session1.html` (Nov 6 2023) | `arrow` in R/Python; reading, writing, partitioning |
| `larger_than_memory_02_duckdb/` | II | `session2.html` (Nov 13 2023) | Choosing a DBMS; SQL basics; `duckdb` |
| `larger_than_memory_03_spark/` | III | `session3.html` (Nov 20 2023) | Apache Spark via `sparklyr` |

Built around the NYC 311 service-request dataset, which is not included;
`larger_than_memory_01_arrow/` retains the 311 data dictionary (`.xlsx`).

## Advanced Geospatial: Data Processing with R and SQL
Mar 2024. Session II only — **session I is not in this handoff.** Deck only,
no `.Rmd` source.

`geospatial_02_r_and_sql/` — `geo_session2.html`, plus `scripts/`
(`01_prep_geocode.sql`, `02_cleanup_tiger.sql`, `03_geocode_example.sql`,
`geo_session2.R`), `scotland_gis/`, `images/`, `figs/`.

## Notes
- `lsh_notes.pdf` (Apr 2025) — locality-sensitive hashing notes; reference
  material, and the companion to record-linkage session III.
