# vi: ft=zsh

export LANG='en_US.UTF-8'
export EDITOR='nvim'
if [[ "${TERM}" != 'alacritty' ]]; then
  export TERM='xterm-256color'
fi

# Replaced by telling antigen to use the asdf bundle
## asdf
#export ASDF_DIR="${XDG_DATA_HOME}/asdf"
#if [[ -f "${ASDF_DIR}/asdf.sh" ]]; then
  #export ASDF_DATA_DIR="${ASDF_DIR}"
  #export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
  #export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME}/asdf/global-tool-versions"
  #export ASDF_SKIP_RESHIM=1
  #source "${ASDF_DIR}/asdf.sh"
  #fpath=(${ASDF_DIR}/completions $fpath)
#fi

# GnuPG
#export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
