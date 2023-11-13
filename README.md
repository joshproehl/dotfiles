# Josh Proehl's Dotfiles

Managed by [Chezmoi](https://www.chezmoi.io).

Currently supports Arch-based, PopOS, Debian, and Fedora systems.

## Installation
Note that we have to do a little dance to install on a new system because chezmoi is what installs our SSH keys. Thus we have to install from HTTPS, and then let Chezmoi run in order to bring in everything.

- Install Chezmoi on new device (system package manager on Arch, or [https://www.chezmoi.io/install/](https://www.chezmoi.io/install/) elsewhere) 
- run `sudo npm install -g @bitwarden/cli` to install BitWarden so we can use it during our first run.
- run `chezmoi init https://gitlab.daedalusdreams.com/joshproehl/dotfiles.git`
- after run completes, make sure you exit your shell, probably log out of the user account, and come back in, otherwise some things aren't going to work...
- Chezmoi will need to have BW unlocked in order to run all scripts and templates. Easiest way to do this is `export BW_SESSION="$(bw unlock --raw)"`. (And close the shell when you're done to re-lock)


During the first run Chezmoi will have run a script that updates the git remotes to the correct SSH transports and urls. Subsequent runs should also use the ASDF provided bitwarden, which will be installed on the 2nd run.


## TODO: 
- Fix initial run using system NPM to install BW. (ASDF doesn't get installed until after the before_ scripts since it's an external repo, so we don't have local ASDF yet and need to manually run `npm install -g @bitwarden/cli`, or otherwise install it from OS packages.
  - Figure out how to at least remove the system-installed version of BW once we've switched to the ASDF managed NPM? (Or maybe just don't care about leaving some junk on the system?)
- Can we get Aura installed automatically on Arch-like systems? (And then be able to install AUR deps via script?)
- Uninstall system NPM after asdf installed?
- Have chezmoi trigger nvim :PlugInstall?
- chezmoi needs to install python-nvim? (from previous install)
  - Looks like it's trying and failing with a "externally-managed-environment" error
- document where to find age password (chezmoi-joshproehl in bitwarden) (put it in script, like the bitwarden client_id instructions?)
- Document "Account Settings -> Security -> Keys -> API Keys" being the way to find the client_id. (Output that into the script)
- First run of `chezmoi update` after unlocking BW requests confirming the gitlab.daedalusdreams.com and github.com SSH key fingerprints. Can we hardcode those? Add another confirmation method? (Running in the script prevents us from doing anything to actually validate the fingerprint)
  - Fingerprints file managed (partially at least?) in chezmoi and copied in before this point?
- Figure out how to deal with `[+++] Installing (N)VIM deps [+++] error: externally-managed-environment` on Arch based systems
- Figure out how to deal with error on first run of `chezmoi update` on a new machine, before unlocking BW:
  ```
    [+++] Installing Antigen [+++]
    /tmp/652021323.b-install-antigen.sh: line 4: /home/joshproehl/.config/zsh/antigen.zsh: No such file or directory
    [===] Antigen Installed [===]
  ```


## Notes:
- PopOS and Debian have different needs and repos, so are treated as different OS'
