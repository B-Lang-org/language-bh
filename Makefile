CONVERT=npx --no -- js-yaml
VSCE=npx vsce
SYNTAXES=bh
JSON_TARGETS=$(addsuffix .json,$(addprefix syntaxes/,$(SYNTAXES)))

# Check that the required packages are installed
# and, if not, suggest to the user the proper way to install
#   Note: the condition to $(if) is consider true if the string is non-empty,
#         so trypkg returns a non-empty string iff the package is found
REQD_PKGS=js-yaml vscode-tmgrammar-test
trypkg=$(shell npx --no -- $(1) -h > /dev/null 2>&1 ; if [ $$? -eq 0 ] ; then echo "found" ; fi)
checkpkg=$(if $(call trypkg,$(1)),,$(error NPM package $(1) not installed, run "npm ci" or "npm install"))
$(foreach pkg,$(REQD_PKGS),$(call checkpkg,$(pkg)))

.PHONY: all
all: grammars 

.PHONY: grammars
grammars: $(JSON_TARGETS)

%.json: %.YAML-tmLanguage
	$(CONVERT) $< > $@

.PHONY: test
test: grammars
	cd test && bash test.sh

.PHONY: publish
publish: all
	$(VSCE) publish

.PHONY: package
package: all
	$(VSCE) package

.PHONY: clean
clean:
	rm -rf node_modules out syntaxes/bh.json language-bh-*.vsix
