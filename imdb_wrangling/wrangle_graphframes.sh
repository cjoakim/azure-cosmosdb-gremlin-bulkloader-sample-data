#!/bin/bash

# Data-wrangling process to create the CSV files for Spark GraphFrames.
# Chris Joakim, Microsoft, January 2022

source venv/bin/activate
python --version

echo 'removing output files...'
rm ../imdb/graphframes*

echo 'graphframes_movie_vertices...'
python main.py graphframes_movie_vertices loader_movie_vertices.csv > ../imdb/graphframes_movie_vertices.csv
python main.py read_graphframes_csv graphframes_movie_vertices.csv
sleep 2

echo 'graphframes_person_vertices...'
python main.py graphframes_person_vertices loader_person_vertices.csv > ../imdb/graphframes_person_vertices.csv
python main.py read_graphframes_csv graphframes_person_vertices.csv
sleep 2

echo 'graphframes_edges movie_to_person ...'
python main.py graphframes_edges loader_movie_to_person_edges.csv > ../imdb/graphframes_movie_to_person_edges.csv
python main.py read_graphframes_csv graphframes_movie_to_person_edges.csv
sleep 2

echo 'graphframes_edges person_to_movie ...'
python main.py graphframes_edges loader_person_to_movie_edges.csv > ../imdb/graphframes_person_to_movie_edges.csv
python main.py read_graphframes_csv graphframes_person_to_movie_edges.csv
sleep 2

echo 'done'
