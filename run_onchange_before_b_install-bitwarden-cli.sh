#!/bin/sh

# Note that on the first run this will install in system NPM,
# and on subsequent runs this should install in the ASDF
# environment. This will cause a tiny bit of pollution, but
# it seems to be the only way to make it work reliably.

npm install -g @bitwarden/cli
