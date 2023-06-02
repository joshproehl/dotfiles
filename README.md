# Josh Proehl's Dotfiles

Managed by Chezmoi.

Currently supports Arch-based, PopOS, Debian, and Fedora systems.

## Installation
- Install Chezmoi on new device (system package manager on Arch, or https://www.chezmoi.io/install/) 
- chezmoi init {REPO HTTPS URL}


## TODO: 
- Fix initial run using system NPM to install BW. (ASDF doesn't get installed until after the before_ scripts, so we don't have local ASDF yet and need to manually run `npm install -g @bitwarden/cli`, or otherwise install it from OS packages.
- can we automatically ensure that chezmoi has its git origin repo changed to SSH so we can push after the initial install via HTTPS?

## Notes:
