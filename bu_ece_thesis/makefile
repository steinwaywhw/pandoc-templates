

PANDOC=/tmp/pandoc-templates
TEMPLATE=bu_ece_thesis

BUILD=./build
OUTPUT=./output
INCLUDE=./include
SRC=.
INPUT=main.md 
BIB=./library.bib
NAME=submission

# SILENT=-interaction=batchmode

all: pdf 

# copy files into build folder
prepare: $(PANDOC)/$(TEMPLATE)/* $(INCLUDE)/* $(BIB)
	mkdir -p $(BUILD) 
	mkdir -p $(OUTPUT)
	cp -rf $(PANDOC)/$(TEMPLATE)/* $(BUILD)/
	cp -rf $(INCLUDE)/* $(BUILD)/
	cp $(BIB) $(BUILD)/



%.tex: %.md
	pandoc \
		-f markdown+raw_tex \
		-t json \
		--smart \
		--highlight-style=pygments \
		$^ \
	| python3 $(INCLUDE)/preserve_comments.py \
	| pandoc \
		-f json \
		-t latex \
		-o $(BUILD)/$@ \
		--highlight-style=pygments \
		--latex-engine=xelatex 


# generate tex file
tex: $(SRC)/$(INPUT) abstract.tex abbrv.tex
	pandoc \
		-f markdown+raw_tex \
		-t json \
		--smart \
		--highlight-style=pygments \
		$(SRC)/$(INPUT) \
	| python3 $(INCLUDE)/preserve_comments.py \
	| pandoc \
		-f json \
		-t latex \
		-o $(BUILD)/$(NAME).tex \
		-s \
		-H $(INCLUDE)/header.tex \
		-B $(INCLUDE)/before.tex \
		-A $(INCLUDE)/after.tex \
		--template=$(PANDOC)/$(TEMPLATE)/$(TEMPLATE).pandoc-template \
		--highlight-style=pygments \
		--latex-engine=xelatex 

	perl -i -p0e 's/^\n% *\n/%/gm' $(BUILD)/$(NAME).tex

bib: tex  
	cd $(BUILD) && xelatex $(SILENT) $(NAME).tex 
	cd $(BUILD) && bibtex $(NAME)

pdf: tex bib  
	cd $(BUILD) && xelatex $(SILENT) $(NAME).tex
	cd $(BUILD) && pdflatex $(SILENT) $(NAME).tex 
	cp $(BUILD)/$(NAME).pdf $(OUTPUT)/

texbib: tex bib
	sed -i -e "/^\\\\bibliography{.*}$$/r $(BUILD)/$(NAME).bbl" -e "//d" $(BUILD)/$(NAME).tex

pdfbib: texbib 
	cd $(BUILD) && xelatex $(SILENT) $(NAME).tex
	cd $(BUILD) && pdflatex $(SILENT) $(NAME).tex 
	cp $(BUILD)/$(NAME).pdf $(OUTPUT)/

clean: 
	rm -rf $(BUILD)

docker: 
	docker run --rm -ti --volume=$$(pwd):/tmp/src steinwaywhw/pandoc

pandoc: 
	cd /tmp && git clone https://github.com/steinwaywhw/pandoc-templates
	cd /tmp/src


