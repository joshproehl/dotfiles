# Josh Proehl's Dotfiles

Managed by [Chezmoi](https://www.chezmoi.io).

Currently supports Arch-based, PopOS, Debian, and Fedora systems.

## Installation
Note that we have to do a little dance to install on a new system because chezmoi is what installs our SSH keys. Thus we have to install from HTTPS, and then let Chezmoi run in order to bring in everything.

- Install Chezmoi on new device (system package manager on Arch, or [https://www.chezmoi.io/install/](https://www.chezmoi.io/install/) elsewhere) 
- run `sudo npm install -g @bitwarden/cli` to install BitWarden so we can use it during our first run.
- run `chezmoi init https://gitlab.daedalusdreams.com/joshproehl/dotfiles.git`
- after run completes, make sure you exit your shell, probably log out of the user account, and come back in, otherwise some things aren't going to work...

During the first run Chezmoi will have run a script that updates the git remotes to the correct SSH transports and urls. Subsequent runs should also use the ASDF provided bitwarden, which will be installed on the 2nd run.


## TODO: 
- Fix initial run using system NPM to install BW. (ASDF doesn't get installed until after the before_ scripts since it's an external repo, so we don't have local ASDF yet and need to manually run `npm install -g @bitwarden/cli`, or otherwise install it from OS packages.
  - Figure out how to at least remove the system-installed version of BW once we've switched to the ASDF managed NPM? (Or maybe just don't care about leaving some junk on the system?)
- Can we get Aura installed automatically on Arch-like systems? (And then be able to install AUR deps via script?)


## Notes:
- PopOS and Debian have different needs and repos, so are treated as different OS'
