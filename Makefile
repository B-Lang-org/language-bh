CONVERT=npx js-yaml
VSCE=npx vsce
SYNTAXES=bh
JSON_TARGETS=$(addsuffix .json,$(addprefix syntaxes/,$(SYNTAXES)))

.PHONY: all publish package

all: grammars 

grammars: $(JSON_TARGETS)

%.json: %.YAML-tmLanguage
	$(CONVERT) $< > $@

test: grammars
	cd test && bash test.sh

publish: all
	$(VSCE) publish

package: all
	$(VSCE) package
