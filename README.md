# mvenv

<p align="left">
     <img src="https://img.shields.io/github/license/rafapi/mvenv">
     <img src="https://img.shields.io/github/last-commit/rafapi/mvenv">
</p>

A minimalist Python venv management tool
### set-up
* Clone this repo: `git clone https://github.com/rafapi/mvenv.git ~/.mvenv`
* Source `mvenv` from `~/.bashrc` or `~/.zshrc`
    ```
    source $HOME/.mvenv/mvenv.sh
    ```
* Open a new shell or run `source $HOME/.mvenv/mvenv.sh` in the current one
### usage
* type `mve` on your shell to see the options.
```
# mve help

CLI Options:
    mve mk <word>         -->   creates a new venv
    mve rm <word>         -->   removes an existing venv
    mve ls <word>         -->   lists all available venvs
    mve activate <word>   -->   activate a venv

    mve help              -->   displays this menu
```
### requirements
* Either `asdf` or `pyenv`
* `Python > 3.4`
