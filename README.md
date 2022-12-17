dotfiles
========

To install, run:
  
    scripts/bootstrap.sh

This will:

1. Automatically link **\*.symlink files** to their respective directories. If the file already exists, it will prompt the user with a number of choices: _backup_, _overwrite_, _skip_. 


### Theme setup
Set the following export in `~/.bashrc.local`
```
export VIM_THEME=kolor
```

### Add new plugins as submodules
```
git submodule add <git-url> <plugin>
git add .
git commit -m ...
```
