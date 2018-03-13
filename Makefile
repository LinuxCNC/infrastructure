HTML=$(patsubst %.adoc, %.html, $(wildcard *.adoc))

all: ${HTML}

%.html: %.adoc
	a2x --verbose --format=xhtml $<
