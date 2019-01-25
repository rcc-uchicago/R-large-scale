# A Makefile for generating the PDFs from the R Markdown files.
#
# * Type "make slides" in this directory to generate a PDF of the
#   slides from the R Markdown source.
#
# * Type "make test" to generate a PDF of the slides that also runs
#   a lot of the R code.
#
# * Optionally, type "make handout" to generate a PDF document that
#   can be used as a handout to distribute to workshop participants,
#   or as an instructor aid. For improved layout, I recommend setting
#   the YAML header in slides.Rmd to
# 
#     ---
#     title: "Introduction to R for data analysis"
#     author: Peter Carbonetto
#     header-includes:
#       - \usepackage{newcent}
#     ---
#
# * Type "make clean" to discard the generated PDFs, and all accompanying
#   output.
#

# RULES
# -----
all: slides 

slides: slides.pdf 

test: slides_test.pdf

handout: handout.pdf

slides_with_notes.Rmd : docs/slides_with_notes.Rmd
	cp docs/slides_with_notes.Rmd slides_with_notes.Rmd

slides.Rmd : slides_with_notes.Rmd
	grep -v '^>' slides_with_notes.Rmd > slides.Rmd

# Create the slides.
slides.pdf : slides.Rmd
	Rscript -e 'knitr::opts_chunk$$set(eval = FALSE); \
rmarkdown::render("slides.Rmd")'

# Create the slides with the instructor's notes.
slides_with_notes.pdf : slides_with_notes.Rmd
	Rscript -e 'knitr::opts_chunk$$set(eval = FALSE); \
rmarkdown::render("slides_with_notes.Rmd",output_format = "pdf_document")'

# Generate the slides while also testing the R code.
slides_test.pdf : slides.Rmd
	Rscript -e 'knitr::opts_chunk$$set(eval = TRUE); \
rmarkdown::render("slides.Rmd",output_file = "slides_test.pdf")'

# Create the handout.
handout.pdf : slides.Rmd
	Rscript -e 'knitr::opts_chunk$$set(eval = FALSE); \
rmarkdown::render("slides.Rmd",output_format = "pdf_document", \
output_file = "handout.pdf")'

clean:
	rm -f slides.pdf slides_test.pdf handout.pdf divvyanalysis.RData
	rm -f slides_with_notes.Rmd station_map.pdf station_map.png
	rm -f slides_with_notes.pdf divvyanalysis.RData

