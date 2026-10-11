# skills-workshops

Workshop materials from Princeton's Data-Driven Social Science (DDSS) initiative.

## Record Linkage Bootcamp for Social Science Data (current)

These files are in the repository root.

- `rl-bootcamp.html`: the slide deck (self-contained HTML).
- `scripts/`: the `.ipynb` demo. It reads `data/demo.db`.
- Python environment: run `uv sync` (see `pyproject.toml` and `.python-version`).

## Legacy workshops

[`legacy/`](legacy/) holds the most recent edition of each earlier DDSS workshop series. Each folder is named `<series>_<session#>_<topic>`. [`legacy/README.md`](legacy/README.md) lists every session's materials and says which data is not included.

| Series | Edition | Folders | Sources |
|---|---|---|---|
| Large data processing with SQL for social science | Fall 2025 | `sql_01`–`sql_03` | Decks, `.Rmd` sources, code-alongs |
| Record Linkage | Spring 2025 (demo rewritten Feb 2026) | `record_linkage_01`–`03` | Decks + `.Rmd` for I–II; no deck for III |
| Larger-than-Memory Data without HPC | Fall 2023 | `larger_than_memory_01`–`03` | Decks only (no `.Rmd`) |
| Advanced Geospatial: Data Processing with R and SQL | Mar 2024 | `geospatial_02` | Session II only, deck + scripts |

`legacy/lsh_notes.pdf` covers locality-sensitive hashing. It goes with record linkage session III.
