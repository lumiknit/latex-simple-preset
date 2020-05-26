# lumiknit's flavored latex presettings
# 20200526
# lumiknit

#-----------------------------------------------------------
MAIN = main

ENV_OS := Unknown
ifeq ($(OS),Windows_NT)
	ENV_OS := Windows
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		ENV_OS := Linux
	endif
	ifeq ($(UNAME_S),Darwin)
		ENV_OS := MacOS
	endif
endif

PDFLATEX = pdflatex -halt-on-error
RM = rm -r
OPEN_PDF :=
ifeq ($(ENV_OS),Windows)
	RM := del
	OPEN_PDF := $(MAIN).pdf
else ifeq ($(ENV_OS),MacOS)
	OPEN_PDF := open "$(MAIN).pdf"
else
	OPEN_PDF := xdg-open "$(MAIN).pdf" > /dev/null 2>&1 &
endif

.PHONY: build_and_open all pdf clean open

build_and_open: *.tex
	@echo "Typesetting..."
	@if $(PDFLATEX) $(MAIN).tex $(PDFLATEXOPT) | grep '^!.*' -A300 --color=auto; then \
		echo ""; \
		echo "[ERROR] Some errors occurred during typesetting!"; \
		exit 0; \
	else \
		echo "Typesetting Done!"; \
		$(OPEN_PDF) \
	fi

all: $(MAIN).pdf open

$(MAIN).pdf: *.tex
	@echo "Typesetting..."
	@if $(PDFLATEX) $(MAIN).tex $(PDFLATEXOPT) | grep '^!.*' -A300 --color=auto; then \
		exit 1; \
	else \
		exit 0; \
	fi

open: $(MAIN).pdf
	@$(OPEN_PDF)

clean:
	$(RM) *.aux *.out *.log *.fls *.fdb_latexmk