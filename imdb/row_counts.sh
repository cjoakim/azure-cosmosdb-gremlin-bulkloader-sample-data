#!/bin/bash

# bash script to get the row counts of the four generated csv files.
# Chris Joakim, Microsoft, January 2022

echo ''
echo 'vertices:'
wc -l loader_movie_vertices.csv
wc -l loader_person_vertices.csv

echo ''
echo 'edges:'
wc -l loader_movie_to_person_edges.csv
wc -l loader_person_to_movie_edges.csv

echo ''
echo 'head -2 each file:'
head -2 loader_movie_vertices.csv
echo ''
head -2 loader_person_vertices.csv
echo ''
head -2 loader_movie_to_person_edges.csv
echo ''
head -2 loader_person_to_movie_edges.csv

# Output:
# vertices:
#    72254 loader_movie_vertices.csv
#   133490 loader_person_vertices.csv

# edges:
#   276552 loader_movie_to_person_edges.csv
#   276552 loader_person_to_movie_edges.csv

# head -2 each file:
# Id,Pk,Label,Title,Year:int,Minutes:int
# tt0015724,tt0015724,Movie,Dama de noche,1993,102

# Id,Pk,Label,Name
# nm0844752,nm0844752,Person,Rafael Sánchez Navarro

# EdgeId,EdgePk,EdgeLabel,FromVertexId,FromVertexPk,FromVertexLabel,ToVertexId,ToVertexPk,ToVertexLabel,epoch:double
# tt0015724-nm0844752,tt0015724-nm0844752,has_person,tt0015724,tt0015724,Movie,nm0844752,nm0844752,Person,1620420702.180296

# EdgeId,EdgePk,EdgeLabel,FromVertexId,FromVertexPk,FromVertexLabel,ToVertexId,ToVertexPk,ToVertexLabel,epoch:double
# nm0844752-tt0015724,nm0844752-tt0015724,is_in,nm0844752,nm0844752,Person,tt0015724,tt0015724,Movie,1620420703.6033332


# File Math:
#   (72254 + 133490)  - 2 header rows => 205742 vertices
#   (276552 + 276552) - 2 header rows => 553102 edges
#      205742 vertices + 553102 edges => 758844 total 

echo ''
