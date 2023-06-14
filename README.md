# Josh Proehl's Dotfiles

Managed by [Chezmoi](https://www.chezmoi.io).

Currently supports Arch-based, PopOS, Debian, and Fedora systems.

## Installation
Note that we have to do a little dance to install on a new system because chezmoi is what installs our SSH keys. Thus we have to install from HTTPS, and then let Chezmoi run in order to bring in everything.

- Install Chezmoi on new device (system package manager on Arch, or [https://www.chezmoi.io/install/](https://www.chezmoi.io/install/) elsewhere) 
- `chezmoi init https://gitlab.daedalusdreams.com/joshproehl/dotfiles.git`


## TODO: 
- Fix initial run using system NPM to install BW. (ASDF doesn't get installed until after the before_ scripts, so we don't have local ASDF yet and need to manually run `npm install -g @bitwarden/cli`, or otherwise install it from OS packages.
- can we automatically ensure that chezmoi has its git origin repo changed to SSH so we can push after the initial install via HTTPS? (also need to run `git push --set-upstream origin master`)
- Automatically install needed ASDF plugins? ASDF doesn't have an "install needed plugins" option, so we'd have to either parse the dot_tool_versions, or keep the install script in sync with plugins there manually.
- Can we get Aura installed automatically on Arch-like systems? (And then be able to install AUR deps via script?)


## Notes:
- PopOS and Debian have different needs and repos, so are treated as different OS'
