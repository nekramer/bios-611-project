.PHONY: clean

clean:
	rm -f source_data/episode_names.csv	

source_data/episode_names.csv: episode_name_scraping.R
	Rscript episode_name_scraping.R