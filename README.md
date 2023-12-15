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
