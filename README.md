# azure-cosmosdb-gemlin-bulkloader-sample-data

This is the companion repository for
[azure-cosmosdb-gemlin-bulkloader](https://github.com/cjoakim/azure-cosmosdb-gemlin-bulkloader).

It contains **CSV** files for graphs which can be loaded into 
**Azure CosmosDB, Graph API** via the **Bulk Loader**.

---

## Sample Graphs

###  IMDb Movies: The Six Degrees of Kevin Bacon

  - See the **imdb/** directory in this repo
  - actors and actresses in movies since 1980
  - Implements an example of the "Six Degrees of Kevin Bacon"
    - https://en.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon
  - Source Data:
    - [IMDb Datasets](https://www.imdb.com/interfaces/)

<p align="center"><img src="img/kevin_bacon_and_lori_singer.jpg" width="80%"></p>

Photo shows **nm0000102** (on left) and **nm0001742** (on right) in movie **tt0087277**.

### IMDb Values of Interest

#### Actors/Actresses

```
nm0000102 = kevin_bacon
nm0000113 = sandra_bullock
nm0000126 = kevin_costner
nm0000148 = harrison_ford
nm0000152 = richard_gere
nm0000158 = tom_hanks
nm0000163 = dustin_hoffman
nm0000178 = diane_lane
nm0000206 = keanu_reeves
nm0000210 = julia_roberts
nm0000234 = charlize_theron
nm0000456 = holly_hunter
nm0000518 = john_malkovich
nm0000849 = javier_bardem
nm0001648 = charlotte_rampling
nm0001742 = lori_singer
nm0001848 = dianne_wiest
nm0005476 = hilary_swank
nm0177896 = bradley_cooper
nm0205626 = viola_davis
nm1297015 = emma_stone
nm2225369 = jennifer_lawrence
```

#### Movies

```
tt0083658 = bladerunner
tt0087089 = cotton_club
tt0087277 = footloose
tt0100405 = pretty_woman
```

---

## Data Wrangling 

See the **imdb_wrangling/** directory for the data wrangling process in scripts 
**wrangle.sh** and **main.py**.  These reduce the huge raw IMDb datasets into 
a smaller subsets of your choosing.

The implementation is in **python 3, with pandas**.

### Python Virtual Environments

It is recommended to use **python virtual environments** so that your multiple
python projects can each use a separate set of libraries, typically downloaded
from [PyPI](https://pypi.org).  There are multiple ways to create python virtual
environments; use the one you prefer.  Regardless of the approach, you should
load your virtual environment for this project using the **requirements.txt**
file in this repo.

I prefer to create python virtual environments with either [pyenv](https://github.com/pyenv/pyenv)
or [venv](https://docs.python.org/3/library/venv.html).  Scripts to do this are in the repo: 
pyenv.sh, venv.sh, and venv.ps1
