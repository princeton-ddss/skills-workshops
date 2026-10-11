
library(data.table)
library(zoomerjoin)
library(stringdist) ## requires igraph

# x = data.table::fread('nc20250101.txt', select = c('first_name', 'status_cd'))[status_cd == 'A']$first_name
# save(x, file = 'nc_first.rda')

load('nc_first.rda')

x_samp = x[sample(1:length(x), 1000, replace = F)]

ssm = stringsimmatrix(x_samp, x_samp, 'jaccard')

hist(
  ssm[upper.tri(ssm, diag = F)],
  main = 'Distr. of random Jaccard sims\nNC\'25 first names',
  xlab = 'Jaccard dist. of random pair'
)

# FROM ZOOMERJOIN DOCUMENTATION:
# As an example, a (.1,.7,.001,.999)-sensitive LSH means that strings with similarity less than .1
# will have a .1% chance of being compared, while strings with .7 similarity
# have a 99.9% chance of being compared.
jaccard_hyper_grid_search(s1 = 0.1, s2 = 0.5, p1 = 0.01, p2 = 0.99)

x_u = unique(x)

out = zoomerjoin::jaccard_string_group(string = x_u, n_gram_width = 2, n_bands = 20, band_width = 4, threshold = 0.7, progress = T)

length(unique(out))

n = data.table(fname = out)[,.N,fname]$N

sum(n*(n-1)/2) ## number of comparisons across all blocks, ~300M

unique(x_u[out == 'GLORIA'])
