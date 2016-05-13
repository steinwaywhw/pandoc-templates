BUILD=./build
OUTPUT=./output
TEMPLATE=sigplanconf
SRC=./src

NAME=draft

all: pdf 

prepare: $(TEMPLATE)/*
	mkdir -p $(BUILD) 
	mkdir -p $(OUTPUT)
	cp -rf $(TEMPLATE)/* $(BUILD)/

tex: prepare $(SRC)/*
	pandoc \
		-t latex \
		-f markdown \
		-o $(BUILD)/$(NAME).tex \
		-s \
		-S \
		-H $(SRC)/header.tex \
		-B $(SRC)/before.tex \
		-A $(SRC)/after.tex \
		--template=./$(TEMPLATE)/$(TEMPLATE).pandoc-template \
		--highlight-style=pygments \
		--latex-engine=xelatex \
		--natbib \
		$(SRC)/*.md

bib: tex 
	cd $(BUILD) && xelatex $(NAME).tex 
	cd $(BUILD) && bibtex $(NAME)

pdf: tex bib 
	cd $(BUILD) && xelatex $(NAME).tex
	cd $(BUILD) && pdflatex $(NAME).tex 
	cp $(BUILD)/$(NAME).pdf $(OUTPUT)/

texbib: tex bib
	sed -i -e "/^\\\\bibliography{.*}$$/r $(BUILD)/$(NAME).bbl" -e "//d" $(BUILD)/$(NAME).tex

pdfbib: texbib 
	cd $(BUILD) && xelatex $(NAME).tex
	cd $(BUILD) && pdflatex $(NAME).tex 
	cp $(BUILD)/$(NAME).pdf $(OUTPUT)/

html: 
	pandoc \
		-t html5 \
		-f markdown \
		-o $(OUTPUT)/$(NAME).html \
		-S \
		-s \
		--filter pandoc-citeproc \
		--katex \
		--highlight-style=pygments \
		$(SRC)/*.md

clean: 
	rm -rf $(BUILD)

docker:
	docker run -ti --rm --volume=$$(pwd):/tmp steinwaywhw/pandoc 

