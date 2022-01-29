#!/bin/bash

# Chris Joakim, Microsoft, January 2022

cat graphframes_movie_vertices.csv  >  graphframes_vertices.csv 
cat graphframes_person_vertices.csv >> graphframes_vertices.csv 

cat graphframes_movie_to_person_edges.csv >  graphframes_edges.csv 
cat graphframes_person_to_movie_edges.csv >> graphframes_edges.csv 

echo 'todo - removed the 2nd embedded header rows!'
