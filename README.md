# Bluespec Classic Highlighting

Starting with Haskell textmate as a basis for Bluespec Classic syntax highlighting.
We started from <https://github.com/JustusAdam/language-haskell>

First, install the JavaScript dependencies with
```
npm install
```
(you only need to do this once).

To build the syntax rules and create the VSCode extension package, run
```
make
npm run package
```

Finally, you can install it either from the GUI or from the command line by running
```
code --install-extension ./language-bh-*.vsix
```
and then restarting VSCode.

To run the test suite, simply call `make test`.
This can be called on a clean repository, as it does not require the package to be built.
It only needs the grammar files, which will be compiled if necessary.
It then runs `vscode-tmgrammar-test` (installing the package in `npx` if necessary)
on all the files in the test suite.
