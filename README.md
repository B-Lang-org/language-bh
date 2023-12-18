# Bluespec Classic Highlighting Support
This mode adapts the Haskell textmate grammar to Bluespec Classic to provide Bluespec Classis syntax highlighting in Visual Studio Code.

The extension is derived from <https://github.com/JustusAdam/language-haskell>


## Syntax highlighting

Adds syntax highlighting support for Bluespec Classic (.bs).
Also adds automatic indentation after `where`, `do`, `->` etc. and surrounding brackets (`[]`, `{}` etc)

![Screenshot Bluespec Classic](/images/screenshot.png?raw=true)

## Bugs

If you happen to notice bugs or have suggestions for improvements visit the [issue
section](https://github.com/B-Lang-org/language-bh/issues) of the
[repository](https://github.com/B-Lang-org/language-bh).

## Themes

This extension provides TextMate scopes for use in syntax highlighting, but the colours displayed
depend on the theme being used.
Unfortunately many themes have incomplete support for the different TextMate scopes, and as a
result different tokens can end up with identical colours.

For a theme that supports all the scopes provided by this extension, see the
[Groovy Lambda theme](https://github.com/sheaf/groovy-lambda).


## Contributing

This project currently uses the `YAML-tmLanguage` format for language grammar.
The grammar can be found in the `syntaxes` directory.
To generate `JSON` grammars (which is the format VS Code expects), we use the Node package `js-yaml` (requires `npx` in PATH):

```sh
npx js-yaml bh.YAML-tmLanguage > bh.json
```

For testing, we use the Node package `vscode-tmgrammar-test`.

To run the test-suite, simply call `make test`.
This will build the grammar files and run `vscode-tmgrammar-test` on all the files in the testsuite.

## Local installation

First, install the JavaScript dependencies with
```sh
npm ci
```

To build the syntax rules and create the VSCode extension package, run
```sh
make
npm run package
```

Finally, you can install it either from the GUI or from the command line by running

```sh
code --install-extension ./language-bh-*.vsix
```
and then restarting VSCode.
