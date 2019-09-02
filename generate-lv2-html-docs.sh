#!/bin/bash

set -e

if [ ! -d mod.lv2 ]; then
  echo "mod.lv2 bundle missing"
  exit
fi

if [ ! -d modgui.lv2 ]; then
  echo "modgui.lv2 bundle missing"
  exit
fi

if (! which lv2specgen.py >/dev/null); then
  echo "lv2specgen.py tool missing"
  exit
fi

if [ ! -d documentation ]; then
  mkdir documentation
fi

if [ ! -f documentation/style.css ]; then
  git clone git@github.com:moddevices/mod-sdk.git --depth 1 -b gh-pages documentation
fi

cp mod.lv2/*    documentation/mod/
cp modgui.lv2/* documentation/modgui/

# Linux distribution packages of LV2 are notoriously outdated.
# Clone the official LV2 repo and adjust the following variable:
LV2SPECGEN="lv2specgen.py"

$LV2SPECGEN $(pwd)/mod.lv2/manifest.ttl $(pwd)/documentation/mod/index.html --style-uri="../style.css" -i -r $(pwd)/documentation/mod -p mod

$LV2SPECGEN $(pwd)/modgui.lv2/manifest.ttl $(pwd)/documentation/modgui/index.html --style-uri="../style.css" -i -r $(pwd)/documentation/modgui -p modgui

sed -i "/group__manifest.html/d" documentation/*/index.html
sed -i "s|../documentation/mod/||" documentation/mod/index.html
sed -i "s|../documentation/modgui/||" documentation/modgui/index.html
