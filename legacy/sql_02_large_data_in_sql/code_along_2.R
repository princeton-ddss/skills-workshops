
suppressPackageStartupMessages({
  library(glue)
  library(uuid)
  library(duckdb)
  library(arrow)
})

o = dbConnect(duckdb('iris.db', read_only = T))

batch_size = 5

thread = as.numeric(commandArgs(trailingOnly = T)[1])

# we count from one -- not zero -- because we are civilized
min_id = 1 + batch_size*(thread - 1)
max_id = batch_size*(thread)

foo = \(i) paste0(i, 'foo')

tmp = dbGetQuery(o, glue('
  select row_n, "Sepal.Length" as sl from iris where row_n >= {min_id} AND row_n <= {max_id}
'))

tmp$output = foo(tmp$sl)

write_parquet(
  tmp[,c('row_n', 'output')],
  glue('output/{uuid::UUIDgenerate()}.parquet')
  )

dbDisconnect(o)

## from terminal, with `parallel` installed:
# parallel --progress -j 8 Rscript code_along_2_batch.R ::: {1..30}

## then in duckdb:
# update iris set (output) = tmp.output from read_parquet('output/*.parquet') tmp where iris.row_n = tmp.row_n
