# Project IV : SQL/Tableau | Marco Ayora Arsic

## Introduction

In this project i will be showing how based on a dataset about the real state market in Madrid we can look for specific properties in Madrid thanks to SQL queries as well as having a bit of an idea of how the market is distributed geographically in terms of buy and rent prices thanks to Tableau.

## Data Source 

The data set was obtained by kaggle, and the geojson file about the Madrid neighborhood was provided by a spanish governement website.

## Methodology

The libraries used are the following:
- For data manipulation //import pandas as pd//import numpy as np

- In order to do the connection between our python notebook and mysql// import pymysql, import sqlalchemy as alch, from dotenv, import load_dotenv, from getpass import getpass

- To print in a more readable format //import pprint

## Overview

To see a global idea on how this project works we first have to look at the notebooks where the dataframe was imported from the csv file downloaded from kaggle. Then visualised to understand the data i was working on.

Then we pass to the cleaning notebook,  in this part of the code we mainly prepare our data to be transfered to Mysql in first place by getting rude of all the null values then separating the dataframe in 5 different dataframes. And finally creating the columns for this dataframes that will be later used for creating the primary and foreign keys in sql.
At the end of the notebook it is observable how the 5 dataframes are imported into mysql.

Onece i had all the dataframes as tables in sql we had to do the connections by the keys seen in code and explained at the beginning of the Mysql file. This lead us to have a sql database that looks like this:

![Alt text](image.png)


Then i realised my sql queries, where we can look for specific properties and filter by certain characteristics like a real state web page would do. One example could be the last query where it first looks for a specific property based on its id and then gives the result of all the properties that are similiar to the property based on the inputed parametres.

The second part of the project would be Tableau where i imported the dataframe as a csv file before dividing it into 5 pieces. Then in order to use one of the columns i needed a spacial column with all the Madrid neighborhoods that i found in a Governement web page. Then in tableau i separated my visualizations into 3 different spreadsheets.

## Tableau analysis

#### link for the Tableau file: https://public.tableau.com/app/profile/marco.ayora/viz/project4marco/Story1?publish=yes

In the first spreadsheet we can observe two same maps of all Madrid divided neighborhoods with its average rent and buy prices being in both 'Recolectos' the most centered one geographically as well as the most expensive.

In the second spreadsheet we first have in the left  the average rent price with a filter only showing properties for rent above 1500€ visually displayed differently than before this time as treemap. Then in the right a box and whisker plot that displays the buy price per square meter built in each property so we can visualize some of the outliers too.

Finally we can see two packed bubbles graphs that analyses the average buy and rent prices by the type of house. Having three different property types; apartments, duplex and penthouse. It is vusally clear to state the differences between each while buying them as the penthouses lead the left graph but the renting prices do not vary that much between them. That could be due by two things; The lately increase in prices of housing in Spain or a mistaken data from the dataset.


## Conclusion

Thanks to the data provided in this database and the tools used i created a lookalike system to navigate over the more than  fifteen thousand properties by looking at its characteristics. In the other hand the fact that we miss lots of geographical data as well as past data of properties that have already been sold or rented in order to analyse the market makes our visualization lack consistancy while it only helps us to understand the current available properties but not to analyse neither the future nor the past.

## Source links:

Madrid dataset: https://www.kaggle.com/datasets/mirbektoktogaraev/madrid-real-estate-market/

Spacial data: https://geoportal.madrid.es/IDEAM_WBGEOPORTAL/dataset.iam?id=422fa235-762b-11e9-861d-ecb1d753f6e8
