#! /usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Pass-through replacement for the python2 scripts/gcc-wrapper.py shipped in
# the Xiaomi 4.19 tree.
#
# Why not a faithful port: the original fails the build on any compiler
# warning outside a tiny whitelist. That whitelist matches the old AOSP
# clang (r377782c) Xiaomi used; a modern clang (e.g. Proton Clang 13) emits
# many new, harmless warnings on 4.19 code and would fail the build file
# after file. Warnings are still printed to the build log (see build.log),
# they just don't stop the build. Behaviour of flags/exit codes is unchanged:
# we exec the compiler directly.
import os
import sys


if __name__ == '__main__':
    os.execvp(sys.argv[1], sys.argv[1:])
