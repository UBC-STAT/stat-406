rmds=$(wildcard *.Rmd)
htmls=$(rmds:.Rmd=.html)


all: $(htmls)
	echo All slides have been rebuilt

%.html: %.Rmd rmd_config.R materials/slides-style.css\
		materials/load-fa.html materials/macros.js\
		materials/xaringan-themer.css
	Rscript -e 'rmarkdown::render("$<")'
	
materials/xaringan-themer.css: xaringan-themer.R
	Rscript -e "source('xaringan-themer.R')"

.PHONY: clean	
clean: 
	rm -f $(htmls)
	rm -rf rmd_gfx
	rm -rf *_cache

.PHONY: webcp
webcp:
	rsync -avz materials ../assets/slides/
	rsync -avz gfx ../assets/slides/
	rsync -avz libs ../assets/slides/
	rsync -avz rmd_gfx ../assets/slides/