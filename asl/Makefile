

BUILD=./build
OUTPUT=./output
INCLUDE=./include
PANDOC=/tmp/pandoc-templates
TEMPLATE=asl
SRC=./
INPUT=*.md 
BIB=./library.bib
NAME=submission

# SILENT=-interaction=batchmode

all: pdfbib

# copy files into build folder
prepare: $(PANDOC)/$(TEMPLATE)/* 
	mkdir -p $(BUILD) 
	mkdir -p $(OUTPUT)
	cp -rf $(PANDOC)/$(TEMPLATE)/*.cls $(PANDOC)/$(TEMPLATE)/*.pandoc-template $(PANDOC)/$(TEMPLATE)/*.bst $(BUILD)/
	cp $(BIB) $(BUILD)/

# generate tex file
tex: prepare $(SRC)/*.md 
	pandoc \
		-f markdown+raw_tex \
		-t latex \
		--smart \
		--highlight-style=pygments \
		-t latex \
		-o $(BUILD)/$(NAME).tex \
		-s \
		--template=$(PANDOC)/$(TEMPLATE)/$(TEMPLATE).pandoc-template \
		--highlight-style=pygments \
		--latex-engine=pdflatex \
		-H $(INCLUDE)/header.tex \
		-B $(INCLUDE)/before.tex \
		-A $(INCLUDE)/after.tex \
		$(SRC)/$(INPUT) 

bib: tex  
	cd $(BUILD) && pdflatex $(SILENT) $(NAME).tex 
	cd $(BUILD) && bibtex $(NAME)

pdf: tex bib  
	cd $(BUILD) && pdflatex $(SILENT) $(NAME).tex
	cd $(BUILD) && pdflatex $(SILENT) $(NAME).tex 
	cp $(BUILD)/$(NAME).pdf $(OUTPUT)/

texbib: tex bib
	sed -i -e "/^\\\\bibliography{.*}$$/r $(BUILD)/$(NAME).bbl" -e "//d" $(BUILD)/$(NAME).tex
	sed -i -e "s/^\\\\begin{thebibliography}{}/\\\\begin{thebibliography}{9}/" $(BUILD)/$(NAME).tex
	# cd $(BUILD) && rm *.aux *.log *.bbl 

pdfbib: texbib 
	cd $(BUILD) && pdflatex $(SILENT) $(NAME).tex 
	cd $(BUILD) && pdflatex $(SILENT) $(NAME).tex 
	cd $(BUILD) && pdflatex $(SILENT) $(NAME).tex 
	cd $(BUILD) && pdflatex $(SILENT) $(NAME).tex 
	cp $(BUILD)/$(NAME).pdf $(OUTPUT)/


clean: 
	rm -rf $(BUILD)

docker: 
	docker run --rm -ti --volume=$$(pwd):/tmp/src steinwaywhw/pandoc

pandoc: 
	cd /tmp && git clone https://github.com/steinwaywhw/pandoc-templates
	cd /tmp/src


