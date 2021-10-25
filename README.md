# BIOS611 Project

## The Great British Bake Off

The Great British Bake Off (GBBO) is one of the most popular baking competitions
of all time. Every week, viewers are able to watch amateur bakers *prove* 
themselves (yes, this is a bread joke) to two pro judges through 3 rounds of 
baking challenges. In such a subjective competition, what really are the 
factors that distinguish a GBBO winner from a soggy bottom?

This project aims to answer some key questions I have when attempting to predict
the outcome of each GBBO episode: Does a particular occupation seem to give
bakers an advantage in the GBBO challenges? To what extent does performance in 
Technical Challenges predict winning? Do "Bread Week" Star Bakers tend to 
win more? Does low performance in the previous episode make someone more likely 
to go home the following week?

### Datasets

Datasets all contain public data from GBBO Series 1-10 obtained through 
Wikipedia. Information in these datasets includes baker information (age, gender,
occupation, hometown), each baker's overall results in the competition as well
as episode-specific rankings, and names of the bakers' Signatures and 
Showstoppers. 

Files included in the `source_data` directory are from Alison Hill's `bakeoff`
data package: https://github.com/apreshill/bakeoff. An additional file of episode
names can be made with `make` in a Bash instance:

```
make source_data/episode_names.csv
```

### Preliminary Figures



### Usage 

You will need Docker and the ability to run Docker as your current user.

In the directory of this repository, first build the Docker container:

```
docker build . -t project-env
```

To run the RStudio server in this container:
```
docker run -v `pwd`:/home/rstudio -p 8787:8787\
    -e PASSWORD=mypassword -t project-env
```
Then connect to the machine on port 8787.

### Making this project

The Makefile included in this repository will build the major components
of the project.
