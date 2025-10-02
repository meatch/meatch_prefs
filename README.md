# meatch_prefs

My Shell settings and preferences

## Oh My Zsh! Shell

-   `Bash` (Bourne Again SHell) is the default shell for most Linux distributions and macOS.
-   `Zsh` (Z Shell) is an extended Bourne shell with many improvements, including better scripting capabilities, improved tab completion, and advanced prompt customization.
-   `.oh-my-zsh` is a framework for managing Zsh configuration and plugins. [Oh My Zsh! Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki)

### Customization/Configuration/Loader Files

-   The `.zshrc` is what loads in the shell to apply Zsh settings, I have symlinked it in `~/` so I can cleany keep this folder under version control.
-   The `.bashrc` is what loads in the shell to apply its framework and configurations - if you are using the default Bash Shell, which we are not. This file can be safely removed to avoid confusion, but see what 3rd party apps are adding there in case you need to port to `.zshrc`


Create Symlinks

```bash
mv ~/.zshrc ~/.zshrc.backup
ln -s ~/meatch_prefs/.zshrc ~/.zshrc

mv ~/.zshrc ~/.bashrc.backup
ln -s ~/meatch_prefs/.bashrc ~/.bashrc
```

