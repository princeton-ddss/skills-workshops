
pacman::p_load('sf', 'areal', 'tidycensus', 'leaflet', 'tidygeocoder', 'nngeo', 'tidyverse')

st_layers('scotland_gis/')

# westminster (MP) districts
mp = st_read('scotland_gis/', query = "SELECT NAME FROM westminster_const_region WHERE SUBSTR(CODE, 1, 1) = 'S' ")

# referendum results by local authority area
rf = st_read('scotland_gis/', query = 'SELECT NAME, Yes, No FROM ScotIndyRef')
# data zones (unevenly dispersed centroids with population aggregates)
dz = st_read('scotland_gis/', query = "SELECT TotPop2011 FROM SG_DataZone_Cent_2011")

# get rid of the islands for this exercise (sorry!)
rf = rf %>% filter(!str_starts(NAME, 'Shetland|Orkney|Na h-Eileanan'))
mp = mp %>% filter(!str_starts(NAME, 'Shetland|Orkney|Na h-Eileanan'))

g = ggplot() +
  theme_void() +
  geom_sf(data = rf, mapping = aes(fill = Yes/(Yes+No))) +
  scale_fill_continuous(labels = scales::label_percent()) +
  labs(fill = '% Yes')

ggsave('figs/ref_results.jpg', plot = g, width = 4, height = 4.5, units = 'in')

g = ggplot() +
  theme_void() +
  geom_sf(data = rf, fill = NA, color = 'darkblue', linetype = 'dashed', linewidth = 0.25) +
  geom_sf(data = mp, fill = NA, color = 'darkred', linetype = 'dashed', linewidth = 0.25)

ggsave('figs/scot_dist.jpg', g, width = 4, height = 4.5, units = 'in')

aw = areal::aw_interpolate(
  .data = mp,
  tid = 'NAME',
  source = rf,
  sid = 'NAME',
  weight = 'total',
  extensive = c('Yes', 'No')
)

pw = tidycensus::interpolate_pw(
  from = rf,
  to = mp,
  to_id = 'NAME',
  extensive = T,
  weights = dz,
  weight_column = 'TotPop2011'
)

diff = pw %>% transmute(
  pw = Yes/(Yes+No),
  aw = as.data.frame(aw %>% transmute(aw = Yes/(Yes+No)))[,1]
)

g = ggplot() +
  theme_void() +
  geom_sf(data=diff, aes(fill=pw-aw)) +
  scale_fill_gradient2() +
  labs(fill = 'PW - AW')

ggsave('figs/ref_results_mp.jpg', plot = g, width = 4, height = 4.5, units = 'in')

# ?tidycensus::census_api_key # set Census API key first time
# tidycensus::load_variables(2020, 'dp') # demographic profile 2020 decennial census

counties = tidycensus::get_decennial(
  geography = 'county', variables = 'P1_001N',
  year = 2020, geometry = T
)

states = tidycensus::get_decennial(
  geography = 'state',  variables = 'P1_001N',
  year = 2020, geometry = T
)

c_center = st_centroid(counties)
s_center = st_centroid(states)

out = nngeo::st_nn(
  c_center, s_center, # what if the dataset is the same?
  sparse = T, k = 1,
  returnDist = F, progress = F, parallel = 1
)

counties = counties %>%
  mutate(nearest = unlist(out)) %>%
  inner_join(
    data.frame(row = 1:nrow(states), state_geo = states$GEOID),
    by = c('nearest' = 'row')
  ) %>%
  mutate(state_not_closest = state_geo != substr(GEOID, 1, 2)) %>%
  filter(! substr(GEOID,1,2) %in% c('02', '15'), as.numeric(GEOID) < 57000)

g = ggplot() + theme_void() +
  geom_sf(data = counties, aes(fill = state_not_closest)) +
  scale_fill_manual(values = c('white','red')) +
  theme(legend.position = 'none')

ggsave('figs/us_counties.jpg', plot = g, width = 8, height = 4.5, units = 'in')

addr = data.frame(a='169 Nassau Street, Princeton, NJ, 08540')

tidygeocoder::geocode(addr, method = 'census', address = 'a', verbose = T)

geocode_combine(
  data.frame(a=c('169 Nassau Street, Princeton, NJ, 08540',
                 'Anfield, Liverpool, UK')),
  queries = list(
    list(method = 'census'),
    list(method = 'osm')
  ),
  global_params = list(address = 'a'),
  cascade = T
)

out = lapply(
  c('osm', 'arcgis', 'census'),
  \(x) geocode(addr, method = x, address = 'a') %>% mutate(class = x)
)

out = bind_rows(out)

leaflet() %>% addTiles() %>% addMarkers(data = out, label = out$class)


