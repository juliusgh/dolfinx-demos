# Makefile
# 
# Converts the report in Markdown to a PDF document using `pandoc`
#
# Run "make" to convert to PDF
#
# Run "make clean" to delete converted file

# Convert all files in this directory that have a .md suffix
SOURCE_DOCS := $(wildcard *.md)

EXPORTED_DOCS=report.pdf

RM=/bin/rm

PANDOC=pandoc

PANDOC_OPTIONS=--from markdown --template eisvogel --listings --toc -s

PANDOC_PDF_OPTIONS=


# Pattern-matching Rules

report.pdf : *.md
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PDF_OPTIONS) -o $@ $(SOURCE_DOCS)


# Targets and dependencies

.PHONY: all clean

all : $(EXPORTED_DOCS)

clean:
	- $(RM) $(EXPORTED_DOCS)