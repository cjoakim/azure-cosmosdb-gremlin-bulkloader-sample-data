#!/bin/bash

# curl script to download the IMDb datasets
# See https://datasets.imdbws.com
# Chris Joakim, Microsoft, May 2021

echo 'removing output files ...'
mkdir -p data/raw/
rm data/raw/*.gz 
rm data/raw/*.tsv 

echo "getting name.basics ..."
curl "https://datasets.imdbws.com/name.basics.tsv.gz" > data/raw/name.basics.tsv.gz

echo "getting title.akas ..."
curl "https://datasets.imdbws.com/title.akas.tsv.gz" > data/raw/title.akas.tsv.gz

echo "getting title.basics ..."
curl "https://datasets.imdbws.com/title.basics.tsv.gz" > data/raw/title.basics.tsv.gz

echo "getting title.crew ..."
curl "https://datasets.imdbws.com/title.crew.tsv.gz" > data/raw/title.crew.tsv.gz

echo "getting title.episode ..."
curl "https://datasets.imdbws.com/title.episode.tsv.gz" > data/raw/title.episode.tsv.gz

echo "getting title.principals ..."
curl "https://datasets.imdbws.com/title.principals.tsv.gz" > data/raw/title.principals.tsv.gz

echo "getting title.ratings ..."
curl "https://datasets.imdbws.com/title.ratings.tsv.gz" > data/raw/title.ratings.tsv.gz

ls -al data/raw/
# -rw-r--r--  1 cjoakim  staff  212470616 May  5 09:27 name.basics.tsv.gz
# -rw-r--r--  1 cjoakim  staff  225848025 May  5 09:27 title.akas.tsv.gz
# -rw-r--r--  1 cjoakim  staff  139955819 May  5 09:27 title.basics.tsv.gz
# -rw-r--r--  1 cjoakim  staff   54495836 May  5 09:27 title.crew.tsv.gz
# -rw-r--r--  1 cjoakim  staff   31241147 May  5 09:27 title.episode.tsv.gz
# -rw-r--r--  1 cjoakim  staff  360665849 May  5 09:28 title.principals.tsv.gz
# -rw-r--r--  1 cjoakim  staff    5684204 May  5 09:28 title.ratings.tsv.gz

echo 'unzipping'
cd data/raw

gunzip name.basics.tsv.gz
gunzip title.akas.tsv.gz
gunzip title.basics.tsv.gz
gunzip title.crew.tsv.gz
gunzip title.episode.tsv.gz
gunzip title.principals.tsv.gz
gunzip title.ratings.tsv.gz

ls -al 
# -rw-r--r--  1 cjoakim  staff   650417050 May  5 09:27 name.basics.tsv
# -rw-r--r--  1 cjoakim  staff  1293014718 May  5 09:27 title.akas.tsv
# -rw-r--r--  1 cjoakim  staff   672137684 May  5 09:27 title.basics.tsv
# -rw-r--r--  1 cjoakim  staff   253666931 May  5 09:27 title.crew.tsv
# -rw-r--r--  1 cjoakim  staff   147456390 May  5 09:27 title.episode.tsv
# -rw-r--r--  1 cjoakim  staff  1959402581 May  5 09:28 title.principals.tsv
# -rw-r--r--  1 cjoakim  staff    19622619 May  5 09:28 title.ratings.tsv

cd ..
echo 'done'
