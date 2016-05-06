BUILD=./build
OUTPUT=./output
TEMPLATE=jfp
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

clean: 
	rm -rf $(BUILD)

