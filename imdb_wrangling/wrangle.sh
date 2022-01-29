#!/bin/bash

# Data-wrangling process for the IMDb Azure CosmosDB BulkLoad dataset.
# Chris Joakim, Microsoft, January 2022

footloose="tt0087277"
kevinbacon="nm0000102"

source venv/bin/activate
python --version

date 

echo '=== FILTERING HUGE RAW IMDB DATA ...'
python main.py filter_title_principals
python main.py filter_names
python main.py filter_movies

echo '=== FILTERING SUMMARY ...'
wc -l   data/raw/title.principals.tsv
wc -l   data/filtered_title_principals.csv
head -3 data/filtered_title_principals.csv
cat     data/filtered_title_principals.csv | grep $footloose
#cat    data/filtered_title_principals.csv | grep $kevinbacon  <-- many movies!

wc -l   data/raw/name.basics.tsv
wc -l   data/filtered_names.csv
head -3 data/filtered_names.csv
cat     data/filtered_names.csv | grep $kevinbacon

wc -l   data/raw/title.basics.tsv
wc -l   data/filtered_movies.csv
head -3 data/filtered_movies.csv
cat     data/filtered_movies.csv | grep $footloose

echo '=== JOINING FILTERED DATASETS ...'
python main.py join_movies_to_principals
python main.py get_unique_principals
python main.py join_names_to_unique_principals

echo '=== JOINING SUMMARY ...'
wc -l   data/joined_movies_to_principals.csv
head -3 data/joined_movies_to_principals.csvcat
cat     data/joined_movies_to_principals.csv | grep $footloose | head -3

wc -l   data/joined_names_to_principals.csv
head -3 data/joined_names_to_principals.csv
cat     data/joined_names_to_principals.csv | grep $kevinbacon | head -3

wc -l   data/unique_principals.csv
head -3 data/unique_principals.csv
cat     data/unique_principals.csv | grep $kevinbacon | head -3

# === JOINING SUMMARY ...
#  1596913 data/joined_movies_to_principals.csv
# tconst,primaryTitle,startYear,runtimeMinutes,nconst,category
# tt0011216,Spanish Fiesta,2019,67,nm0290157,actress
# tt0011216,Spanish Fiesta,2019,67,nm0300388,actor

#  1286023 data/joined_names_to_principals.csv
# runtimeMinutes,nconst,primaryName
# 67,nm0290157,Ève Francis
# 67,nm0300388,Gabriel Gabrio

#  1287046 data/unique_principals.csv
# runtimeMinutes,nconst
# 67,nm0290157
# 67,nm0300388

echo '=== CREATE VERTEX AND EDGE CSV FILES FOR BULKLOADER ...'
python main.py create_movie_vertices > data/loader_movie_vertices.csv
python main.py create_person_vertices > data/loader_person_vertices.csv
python main.py create_movie_to_person_edges > data/loader_movie_to_person_edges.csv
python main.py create_person_to_movie_edges > data/loader_person_to_movie_edges.csv

echo '=== BULKLOADER CSV SUMMARY ...'
wc -l   data/loader_movie_vertices.csv
wc -l   data/loader_person_vertices.csv
wc -l   data/loader_movie_to_person_edges.csv
wc -l   data/loader_person_to_movie_edges.csv

date

echo 'done'
