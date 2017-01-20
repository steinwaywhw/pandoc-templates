

BUILD=./build
OUTPUT=./output
INCLUDE=./include
PANDOC=../../pandoc-templates
TEMPLATE=lipics-v2016
SRC=./
INPUT=*.md 
BIB=./library.bib

# SILENT=-interaction=batchmode

NAME=submission

all: pdf 

# copy files into build folder
prepare: $(PANDOC)/$(TEMPLATE)/* $(INCLUDE)/* $(BIB)
	mkdir -p $(BUILD) 
	mkdir -p $(OUTPUT)
	cp -rf $(PANDOC)/$(TEMPLATE)/*.pandoc-template $(PANDOC)/$(TEMPLATE)/*.cls $(BUILD)/
	cp -rf $(INCLUDE)/* $(BUILD)/
	cp $(BIB) $(BUILD)/

# generate tex file
tex: prepare $(SRC)/*.md 
	pandoc \
		-f markdown+raw_tex \
		-t latex \
		-o $(BUILD)/$(NAME).tex \
		-s \
		--smart \
		-H $(INCLUDE)/header.tex \
		-B $(INCLUDE)/before.tex \
		-A $(INCLUDE)/after.tex \
		--template=$(PANDOC)/$(TEMPLATE)/$(TEMPLATE).pandoc-template \
		--highlight-style=pygments \
		--latex-engine=xelatex \
		$(SRC)/$(INPUT)
		# --natbib \
		# $(SRC)/$(INPUT)

	perl -i -p0e 's/^\n\\begin\{multline\*\}/%\n\\begin\{multline\*\}/gm' $(BUILD)/$(NAME).tex
	perl -i -p0e 's/\\end\{multline\*\}\n^\n/\\end\{multline\*\}\n%\n/gm' $(BUILD)/$(NAME).tex
	perl -i -p0e 's/^\n\\begin\{align\*\}/%\n\\begin\{align\*\}/gm' $(BUILD)/$(NAME).tex
	perl -i -p0e 's/\\end\{align\*\}\n^\n/\\end\{align\*\}\n%\n/gm' $(BUILD)/$(NAME).tex
	perl -i -p0e 's/^\n\\begin\{gather\*\}/%\n\\begin\{gather\*\}/gm' $(BUILD)/$(NAME).tex
	perl -i -p0e 's/\\end\{gather\*\}\n^\n/\\end\{gather\*\}\n%\n/gm' $(BUILD)/$(NAME).tex
	perl -i -p0e 's/^\n\\begin\{lstlisting\}/%\n\\begin\{lstlisting\}/gm' $(BUILD)/$(NAME).tex
	perl -i -p0e 's/\\end\{lstlisting\}\n^\n/\\end\{lstlisting\}\n%\n/gm' $(BUILD)/$(NAME).tex
	perl -i -p0e 's/^\n\\begin\{figure\}/%\n\\begin\{figure\}/gm' $(BUILD)/$(NAME).tex
	perl -i -p0e 's/\\end\{figure\}\n^\n/\\end\{figure\}\n%\n/gm' $(BUILD)/$(NAME).tex


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


