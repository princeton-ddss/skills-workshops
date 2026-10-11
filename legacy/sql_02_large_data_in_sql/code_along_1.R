
library(duckdb)
library(glue)

# Setup -------------------------------------------------------------------

o = dbConnect(duckdb())

dbWriteTable(o, 'iris', iris, overwrite = T)

dbGetQuery(o, 'from iris limit 1') # look at top of data -- looks good

# https://duckdb.org/docs/sql/statements/create_sequence.html 
dbExecute(o, 'create sequence x')

# create row number column to track rows
dbExecute(o, "alter table iris add column row_n int default nextval('x')")

# instantiate output column (here, some text -- might be anything)
dbExecute(o, 'alter table iris add column output text default null')

# create 'processed' flag; none processed yet, so false -- ultimately all will be true
dbExecute(o, 'alter table iris add column processed boolean default false')

dbGetQuery(o, 'from iris limit 1')

# Loop --------------------------------------------------------------------

batch_size = 5

rows_left = Inf

foo = \(i) paste0(i, 'foo')

# while there are rows left to be processed
while(rows_left > 0){ 
  
  print(rows_left)
  
  # pull the next five; pull only columns you need for processing + row_n col
  tmp = dbGetQuery(o, glue('select row_n, "Sepal.Length" as sl from iris where processed = false limit {batch_size}'))
  
  tmp$output = foo(tmp$sl)
  
  # write back
  dbWriteTable(o, 'tmp', tmp[,c('row_n', 'output')], overwrite = T, temporary = T)
  
  # update the columns
  dbExecute(o, 'update iris set (output, processed) = (tmp.output, true) from tmp where iris.row_n = tmp.row_n')
  
  rows_left = dbGetQuery(o, 'select count(*) as n from iris where processed = false')$n
}


dbGetQuery(o, 'from iris limit 1')

dbGetQuery(o, 'drop sequence x')

dbDisconnect(o)
