

-- create table vf as from read_csv('data/VR_Snapshot_20170101.zip') ; 

install shellfs from community; 
load shellfs; 

-- create table vf as from read_csv('unzip -p data/VR_Snapshot_20170101.zip |')

install encodings; 
load encodings;

create table vf17 as
  select ncid, party_desc as party_desc_17
  from read_csv('unzip -p data/VR_Snapshot_20170101.zip |', encoding = 'utf-16')
  where status_cd = 'A';

create table vf25 as
  select ncid, party_desc as party_desc_25
  from read_csv('unzip -p data/VR_Snapshot_20250101.zip |', encoding = 'utf-16')
  where status_cd = 'A';

create table switchers as
  select party_desc17, party_desc25, count(*) as n
  from vf17 l
  inner join vf25 r
  -- on l.ncid = r.ncid
  using (ncid)
  group by party_desc17, party_desc25
  order by n desc;

select
  *,
  round(n/(select sum(n) from switchers),4) as prop
from switchers ;



