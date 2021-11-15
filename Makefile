.PHONY: clean
SHELL: /bin/bash


all: source_data/episode_names.csv derived_data/winning_data.csv\
	derived_data/series10_episode_predictors.csv\
	derived_data/first_eliminations.csv\
	derived_data/technical_model.rda\
	figures/roc_technical.png\
	figures/winner_number_starbakers.png\
	figures/winner_number_technicals.png\
	derived_data/winner_model.rda\
	figures/roc_winner.png\
	figures/series10_predictions.png\
	figures/first_losers_technicals.png\
	assets/winner_number_starbakers.png\
	assets/winner_number_technicals.png\
	assets/first_losers_technicals.png\
	report.pdf
	

report.pdf: report.Rmd\
	derived_data/winner_model.rda\
	figures/roc_winner.png\
	figures/series10_predictions.png\
	derived_data/technical_model.rda\
	figures/roc_technical.png
		Rscript -e "rmarkdown::render('report.Rmd', output_format = 'pdf_document')"

clean:
	rm -f source_data/episode_names.csv
	rm -f derived_data/*.csv
	rm -f figures/*.png

source_data/episode_names.csv: episode_name_scraping.R
	Rscript episode_name_scraping.R
	
derived_data/winning_data.csv derived_data/series10_episode_predictors.csv:\
	source_data/episode_names.csv\
	source_data/episode_results.csv\
	source_data/baker_results.csv\
	source_data/challenge_results.csv\
	tidy_win_data.R
		mkdir -p derived_data
		Rscript tidy_win_data.R

derived_data/first_eliminations.csv:\
	source_data/episode_results.csv\
	source_data/challenge_results.csv\
	tidy_lose_data.R
		mkdir -p derived_data
		Rscript tidy_lose_data.R
		
derived_data/technical_model.rda figures/roc_technical.png:\
	source_data/challenge_results.csv\
	utils.R\
	technical_losing_modeling.R
		mkdir -p derived_data
		mkdir -p figures
		Rscript technical_losing_modeling.R

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

derived_data/winner_model.rda figures/roc_winner.png figures/series10_predictions.png:\
	derived_data/winning_data.csv\
	derived_data/series10_episode_predictors.csv\
	winner_modeling.R\
	utils.R
		mkdir -p derived_data
		mkdir -p figures
		Rscript winner_modeling.R
			
figures/first_losers_technicals.png:\
	loser_figures.R\
	derived_data/first_eliminations.csv
		mkdir -p figures
		Rscript loser_figures.R
		
assets/winner_number_starbakers.png assets/winner_number_technicals.png:\
	figures/winner_number_starbakers.png
		cp figures/winner_number_starbakers.png assets/winner_number_starbakers.png
		cp figures/winner_number_technicals.png assets/winner_number_technicals.png
		
assets/first_losers_technicals.png: figures/first_losers_technicals.png
	cp figures/first_losers_technicals.png assets/first_losers_technicals.png
	
shiny_app: source_data/baker_results.csv shinyapp.R
	Rscript shinyapp.R ${PORT}