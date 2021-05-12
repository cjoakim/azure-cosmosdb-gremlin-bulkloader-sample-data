
import csv
import json
import os
import sys
import time

import numpy as np
import pandas as pd

# Python script do two major functions:
# 1) Filter/prune huge raw IMDb *.tsv files into a smaller logical subset
#    of *.csv files for a Movies-to-Actor/Actress graph.
#    Movies since 1980, 100-minutes or longer, actors and actresses.
# 2) Transform the subset csv files into the csv format required by
#    the Azure CosmosDB Graph BulkLoader program.
#
# Chris Joakim, Microsoft, 2021/05/07

# Interesting values:
#   tt0087277 Footloose
#   nm0000102 Kevin Bacon

# filenames
RAW_TITLE_PRINCIPALS='data/raw/title.principals.tsv'
RAW_NAME_BASICS='data/raw/name.basics.tsv'
RAW_TITLE_BASICS='data/raw/title.basics.tsv'
FILTERED_TITLE_PRINCIPALS='data/filtered_title_principals.csv'
FILTERED_NAMES='data/filtered_names.csv'
FILTERED_MOVIES='data/filtered_movies.csv'
JOINED_MOVIES_TO_PRINCIPALS='data/joined_movies_to_principals.csv'
JOINED_NAMES_TO_PRINCIPALS='data/joined_names_to_principals.csv'
UNIQUE_PRINCIPALS='data/unique_principals.csv'

def filter_title_principals():
    print('=== filter_title_principals...')
    drop_cols = list()
    drop_cols.append('ordering')
    drop_cols.append('job')
    drop_cols.append('characters')

    df = pd.read_csv(RAW_TITLE_PRINCIPALS, delimiter="\t")
    describe_df(df, 'df raw title.principals')

    print('=== df.drop cols: {}'.format(drop_cols))
    df2 = df.drop(drop_cols, axis=1)
    describe_df(df2, 'df2 dropped cols')

    print('=== df.category.unique')
    print(df.category.unique())

    categories = list()
    categories.append('self')
    categories.append('cinematographer')
    categories.append('composer')
    categories.append('producer')
    categories.append('editor')
    categories.append('writer')
    categories.append('production_designer')
    categories.append('archive_footage')
    categories.append('archive_sound')
    categories.append('director')

    for c in categories:
        print('dropping category {} ...'.format(c))
        index_names = df2[ df2['category'] == c ].index
        df2.drop(index_names, inplace = True) 
    describe_df(df2, 'df2 after dropping categories')

    print('=== df2.category.unique')
    print(df2.category.unique())

    df2.to_csv(FILTERED_TITLE_PRINCIPALS, index=False)

def filter_names():
    print('=== filter_names...')
    drop_cols = list()
    drop_cols.append('birthYear')
    drop_cols.append('deathYear')
    drop_cols.append('primaryProfession')
    drop_cols.append('knownForTitles')

    df = pd.read_csv(RAW_NAME_BASICS, delimiter="\t")
    describe_df(df, 'df raw name.basics')

    print('=== df2.drop...')
    df2 = df.drop(drop_cols, axis=1)
    describe_df(df, 'df2 after drop cols')

    df2.to_csv(FILTERED_NAMES, index=False)

def filter_movies():
    # Movies since 1980, 100-minutes or longer
    print('=== filter_movies...')
    drop_cols = list()
    drop_cols.append('originalTitle')
    drop_cols.append('endYear')
    drop_cols.append('genres')

    df = pd.read_csv(RAW_TITLE_BASICS, delimiter="\t")
    describe_df(df, 'df raw name.basics')

    print('=== df.drop...')
    df2 = df.drop(drop_cols, axis=1)
    describe_df(df, 'df2 after drop cols')

    print('=== df2.titleType.unique')
    print(df2.titleType.unique())
    # ['short' 'movie' 'tvShort' 'tvMovie' 'tvSeries' 'tvEpisode' 'tvMiniSeries'
    #  'tvSpecial' 'video' 'videoGame']
    types = list()
    types.append('short')
    types.append('tvShort')
    types.append('tvMovie')
    types.append('tvSeries')
    types.append('tvEpisode')
    types.append('tvMiniSeries')
    types.append('tvSpecial')
    types.append('video')
    types.append('videoGame')

    for t in types:
        print('dropping type {} ...'.format(t))
        index_names = df2[ df2['titleType'] == t ].index
        df2.drop(index_names, inplace = True) 
    describe_df(df2, 'df2 after dropping titleTypes')

    print('=== df2.isAdult.unique')
    print(df2.isAdult.unique())
    # [0 1 2019 1981 2020 2017 '0' '1' '\\N' 2014 2005]
    values = list()
    values.append('short')
    values.append('tvShort')
    values.append('tvMovie')
    values.append('tvSeries')
    values.append('tvEpisode')
    values.append('tvMiniSeries')
    values.append('tvSpecial')
    values.append('video')
    values.append('videoGame')
    for v in values:
        print('dropping isAdult {} ...'.format(v))
        index_names = df2[ df2['isAdult'] == v ].index
        df2.drop(index_names, inplace = True) 
    describe_df(df2, 'df2 after dropping isAdult')

    drop_cols = list()
    drop_cols.append('titleType')
    drop_cols.append('isAdult')
    print('=== df.drop...')
    df3 = df2.drop(drop_cols, axis=1)
    describe_df(df3, 'df3 after drop cols')

    index_names = df3[df3['startYear'] == "\\N" ].index
    df3.drop(index_names, inplace=True) 

    df4 = df3[df3['startYear'].astype(int) >= 1980] 
    describe_df(df4, 'df4 after drop years')

    index_names = df4[df4['runtimeMinutes'] == "\\N" ].index
    df4.drop(index_names, inplace=True) 

    df5 = df4[df4['runtimeMinutes'].astype(int) >= 100] 
    describe_df(df5, 'df5 after drop runtimeMinutes')

    df5.to_csv(FILTERED_MOVIES, index=False)

def join_movies_to_principals():
    print('=== join_movies_to_principals...')
    movies_df = pd.read_csv(FILTERED_MOVIES)
    describe_df(movies_df, 'movies_df')

    principals_df = pd.read_csv(FILTERED_TITLE_PRINCIPALS)
    describe_df(principals_df, 'principals_df')

    joined_df = movies_df.merge(
        right=principals_df, how="inner", on="tconst").drop_duplicates()

    describe_df(joined_df, 'joined_df')
    joined_df.to_csv(JOINED_MOVIES_TO_PRINCIPALS, index=False)

def get_unique_principals():
    print('=== get_unique_principals...')
    drop_cols = list()
    drop_cols.append('tconst')
    drop_cols.append('primaryTitle')
    drop_cols.append('startYear')
    drop_cols.append('category')
    drop_cols.append('runtimeMinutes')

    df = pd.read_csv(JOINED_MOVIES_TO_PRINCIPALS)
    describe_df(df, 'df joined_movies_to_principals_csv')

    print('=== df.drop cols: {}'.format(drop_cols))
    unique_principals_df = df.drop(drop_cols, axis=1).drop_duplicates()

    describe_df(unique_principals_df, 'unique_principals_df')
    unique_principals_df.to_csv(UNIQUE_PRINCIPALS, index=False)

def join_names_to_unique_principals():
    print('=== join_names_to_unique_principals...')
    names_df = pd.read_csv(FILTERED_NAMES)
    describe_df(names_df, 'names_df')

    unique_principals_df = pd.read_csv(UNIQUE_PRINCIPALS)
    describe_df(unique_principals_df, 'unique_principals_df')

    joined_df = unique_principals_df.merge(
        right=names_df, how="inner", on="nconst").drop_duplicates()

    describe_df(joined_df, 'joined_df')
    joined_df.to_csv(JOINED_NAMES_TO_PRINCIPALS, index=False)

def create_movie_vertices():
    line_num = 0
    with open(FILTERED_MOVIES, 'rt') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            line_num = line_num + 1
            if line_num == 1:
                print('Id,Pk,Label,Title,Year:int,Minutes:int')
            else:
                try:
                    tconst = row[0]
                    title  = row[1].replace(',','').replace('"',"'")
                    year   = int(row[2])
                    minutes = int(row[3])
                    print('{},{},{},{},{},{}'.format(tconst,tconst,'Movie',title,year,minutes))
                except:
                    pass

def create_person_vertices():
    line_num = 0
    with open(JOINED_NAMES_TO_PRINCIPALS, 'rt') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            line_num = line_num + 1
            if line_num == 1:
                print('Id,Pk,Label,Name')
            else:
                try:
                    nconst = row[0]
                    name   = row[1].replace(',','').replace('"',"'")
                    print('{},{},{},{}'.format(nconst,nconst,'Person',name))
                except:
                    pass

def create_movie_to_person_edges():
    line_num = 0
    with open(JOINED_MOVIES_TO_PRINCIPALS, 'rt') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            line_num = line_num + 1
            if line_num == 1:
                print('EdgeId,EdgePk,EdgeLabel,FromVertexId,FromVertexPk,FromVertexLabel,ToVertexId,ToVertexPk,ToVertexLabel,epoch:double')
            else:
                tconst = row[0]
                nconst = row[4]
                id_pk = '{}-{}'.format(tconst, nconst)
                epoch = time.time()
                print('{},{},{},{},{},{},{},{},{},{}'.format(id_pk, id_pk, 'has_person', tconst, tconst, 'Movie', nconst, nconst, 'Person', epoch))

def create_person_to_movie_edges():
    line_num = 0
    with open(JOINED_MOVIES_TO_PRINCIPALS, 'rt') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            line_num = line_num + 1
            if line_num == 1:
                print('EdgeId,EdgePk,EdgeLabel,FromVertexId,FromVertexPk,FromVertexLabel,ToVertexId,ToVertexPk,ToVertexLabel,epoch:double')
            else:
                tconst = row[0]
                nconst = row[4]
                id_pk = '{}-{}'.format(nconst, tconst)
                epoch = time.time()
                print('{},{},{},{},{},{},{},{},{},{}'.format(id_pk, id_pk, 'is_in', nconst, nconst, 'Person', tconst, tconst, 'Movie', epoch))

def describe_df(df, msg):
    print('=== describe df: {}'.format(msg))
    print('--- df.head(3)')
    print(df.head(3))
    print('--- df.dtypes')
    print(df.dtypes)
    print('--- df.shape')
    print(df.shape)


if __name__ == "__main__":

    if len(sys.argv) > 1:
        func = sys.argv[1].lower()

        # raw file filtering and preprocessing with pandas
        if func == 'filter_title_principals':
            filter_title_principals()
        elif func == 'filter_names':
            filter_names()
        elif func == 'filter_movies':
            filter_movies()

        # join the above filtered files, produce smaller outputs
        elif func == 'join_movies_to_principals':
            join_movies_to_principals()
        elif func == 'get_unique_principals':
            get_unique_principals()
        elif func == 'join_names_to_unique_principals':
            join_names_to_unique_principals()

        # csv reformatting for the bulkloader
        elif func == 'create_movie_vertices':
            create_movie_vertices()
        elif func == 'create_person_vertices':
            create_person_vertices()
        elif func == 'create_movie_to_person_edges':
            create_movie_to_person_edges()
        elif func == 'create_person_to_movie_edges':
            create_person_to_movie_edges()
        else:
            print('undefined function: {}'.format(func))
    else:
        print("no command-line function given")
