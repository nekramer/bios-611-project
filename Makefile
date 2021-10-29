.PHONY: clean
SHELL: /bin/bash

clean:
	rm -f source_data/episode_names.csv
	rm -f derived_data/*.csv
	rm -f figures/*.png

source_data/episode_names.csv: episode_name_scraping.R
	Rscript episode_name_scraping.R
	
derived_data/winning_data.csv:\
	source_data/episode_names.csv\
	source_data/episode_results.csv\
	source_data/baker_results.csv\
	tidy_win_data.R
		mkdir -p derived_data
		Rscript tidy_win_data.R

derived_data/first_eliminations.csv:\
	source_data/episode_results.csv\
	source_data/challenge_results.csv\
	tidy_lose_data.R
		mkdir -p derived_data
		Rscript tidy_lose_data.R
		
figures/winner_number_starbakers.png:\ 
		winner_figures.R\
		derived_data/winning_data.csv
			mkdir -p figures
			Rscript winner_figures.R
			
figures/winner_number_technicals.png:\
		winner_figures.R\
		derived_data/winning_data.csv
			mkdir -p figures
			Rscript winner_figures.R
			
figures/first_losers_technicals.png:\
	loser_figures.R\
	derived_data/first_eliminations.csv
		mkdir -p figures
		Rscript loser_figures.R
		
assets/winner_number_starbakers.png:\ 
	figures/winner_number_starbakers.png
		cp figures/winner_number_starbakers.png assets/winner_number_starbakers.png
		
assets/winner_number_technicals.png:\		
	figures/winner_number_starbakers.png
		cp figures/winner_number_technicals.png assets/winner_number_technicals.png
		
assets/first_losers_technicals.png: figures/first_losers_technicals.png
	cp figures/first_losers_technicals.png assets/first_losers_technicals.png
	
shiny_app: source_data/baker_results.csv shinyapp.R
	Rscript shinyapp.R ${PORT}