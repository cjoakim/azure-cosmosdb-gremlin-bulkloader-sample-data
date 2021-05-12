#!/bin/bash

# bash script to get the row counts of the four generated csv files.
# Chris Joakim, Microsoft, 2021/05/07

echo 'vertices:'
wc -l loader_movie_vertices.csv
wc -l loader_person_vertices.csv

echo 'edges:'
wc -l loader_movie_to_person_edges.csv
wc -l loader_person_to_movie_edges.csv

# Output:
# vertices:
#    72254 loader_movie_vertices.csv
#   133490 loader_person_vertices.csv
# edges:
#   276552 loader_movie_to_person_edges.csv
#   276552 loader_person_to_movie_edges.csv

# (72254 + 133490)  - 2 header rows => 205742 vertices
# (276552 + 276552) - 2 header rows => 553102 edges

echo ''
