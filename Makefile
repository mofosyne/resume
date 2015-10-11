SRC = $(wildcard *.md)

PDFS=$(SRC:.md=.pdf)
HTML=$(SRC:.md=.html)
LATEX_TEMPLATE=./pandoc-templates/default.latex

BUILD_FOLDER=build

# main makefile routines

all:    clean $(PDFS) $(HTML)

pdf:   clean $(PDFS)
html:  clean $(HTML)

%.html: %.md
	python resume.py html $(GRAVATAR_OPTION) < $< | pandoc $(PANDOCARGS_HTML) -t html -c resume.css -o ./$(BUILD_FOLDER)/$@

%.pdf:  %.md $(LATEX_TEMPLATE)
	python resume.py tex < $< | pandoc $(PANDOCARGS) --template=$(LATEX_TEMPLATE) -H header.tex -o ./$(BUILD_FOLDER)/$@

ifeq ($(OS),Windows_NT)
  # on Windows (/s : Deletes specified files from the current dir and all subdir.)
  RM = cmd /C del /S
  MKDIR = mkdir
  # http://stackoverflow.com/questions/3477418/suppress-make-rule-error-output
  ERRORSUPPRESS = ||: true
else
  # on Unix (using recurive -r, and force -f)
  RM = rm -rf
  MKDIR = mkdir -p
  ERRORSUPPRESS = || true
endif

clean:
	$(RM) $(BUILD_FOLDER)
	$(MKDIR) $(BUILD_FOLDER) $(ERRORSUPPRESS) 
#$(RM) *.html *.pdf

$(LATEX_TEMPLATE):
	git submodule update --init
