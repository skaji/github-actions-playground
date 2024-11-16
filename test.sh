#!/bin/bash

set -x

curl -fsSL --compressed https://raw.githubusercontent.com/skaji/cpm/main/cpm > cpm

/usr/bin/perl cpm install File::pushd Path::Tiny
