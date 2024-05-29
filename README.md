# Josh Proehl's Dotfiles

Managed by [Chezmoi](https://www.chezmoi.io).

Currently supports Arch-based, PopOS, Debian, and Fedora systems.

## Installation

Note that we have to do a little dance to install on a new system because
chezmoi is what installs our SSH keys. Thus we have to install from HTTPS,
and then let Chezmoi run in order to bring in everything.

- Install Chezmoi on new device (system package manager on Arch, or
  [https://www.chezmoi.io/install/](https://www.chezmoi.io/install/) elsewhere)
- (if necessary) install system NPM using package manager
- run `sudo npm install -g @bitwarden/cli` to install BitWarden so we can use
  it during our first run.
- run `chezmoi init https://gitlab.daedalusdreams.com/joshproehl/dotfiles.git`
- run `chezmoi apply` to install
- after run completes, make sure you exit your shell, probably log out of the
  user account, and come back in, otherwise some things aren't going to work...
- after logging back in, run `asdf install` in home folder to install necessary
  tool versions. (including NPM, which future chezmoi runs will require)
- (optional) Remove system NPM now that we're using ASDF.

Chezmoi will need to have BW unlocked in order to run all scripts and templates.
Easiest way to do this is `export BW_SESSION="$(bw unlock --raw)"`. (And close
the shell when you're done to re-lock)

During the first run Chezmoi will have run a script that updates the git remotes
to the correct SSH transports and urls. Subsequent runs should also use the ASDF
provided bitwarden, which will be installed on the 2nd run.

## TODO

- Can we get Aura installed automatically on Arch-like systems? (And then be
  able to install AUR deps via script?) Maybe auto-detect if yay exists instead?
- document where to find age password (chezmoi-joshproehl in bitwarden) (put it
  in script, like the bitwarden client_id instructions?)
- First run of `chezmoi update` after unlocking BW requests confirming the
  gitlab.daedalusdreams.com and github.com SSH key fingerprints. Can we hardcode
  those? Add another confirmation method? (Running in the script prevents us from
  doing anything to actually validate the fingerprint)
  - Fingerprints file managed (partially at least?) in chezmoi and copied in
    before this point?
- Figure out how to deal with error on first run of `chezmoi update` on a new
  machine, before unlocking BW:

  ```
    [+++] Installing Antigen [+++]
    /tmp/652021323.b-install-antigen.sh: line 4: /home/joshproehl/.config/zsh/antigen.zsh: No such file or directory
    [===] Antigen Installed [===]
  ```

## Notes

- PopOS and Debian have different needs and repos, so are treated as different OS'
