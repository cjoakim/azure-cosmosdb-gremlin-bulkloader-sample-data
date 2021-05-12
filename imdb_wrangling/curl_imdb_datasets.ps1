#!/bin/bash

# curl script to download the IMDb datasets
# See https://datasets.imdbws.com
# Chris Joakim, Microsoft, May 2021

echo 'removing output files ...'
mkdir data\raw\

echo "getting name.basics ..."
curl "https://datasets.imdbws.com/name.basics.tsv.gz" > data\raw\name.basics.tsv.gz

echo "getting title.akas ..."
curl "https://datasets.imdbws.com/title.akas.tsv.gz" > data\raw\title.akas.tsv.gz

echo "getting title.basics ..."
curl "https://datasets.imdbws.com/title.basics.tsv.gz" > data\raw\title.basics.tsv.gz

echo "getting title.crew ..."
curl "https://datasets.imdbws.com/title.crew.tsv.gz" > data\raw\title.crew.tsv.gz

echo "getting title.episode ..."
curl "https://datasets.imdbws.com/title.episode.tsv.gz" > data\raw\title.episode.tsv.gz

echo "getting title.principals ..."
curl "https://datasets.imdbws.com/title.principals.tsv.gz" > data\raw\title.principals.tsv.gz

echo "getting title.ratings ..."
curl "https://datasets.imdbws.com/title.ratings.tsv.gz" > data\raw\title.ratings.tsv.gz

echo 'files downloaded, now manually unzip each *.gz file in data\raw\'
