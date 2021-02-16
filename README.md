# mvenv
A Python 3 Virtual Environment Management Tool
### set-up
* Clone this repo: `git clone https://github.com/rafapi/mvenv.git ~/.mvenv`
* Add and the following to your `~/.bashrc` or `~/.zshrc`
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
* Either `asdf` or `pyenv` has been made a hard requirement to encourage good habits.
