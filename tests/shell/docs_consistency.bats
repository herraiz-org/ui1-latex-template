#!/usr/bin/env bats
# Copyright 2026 Israel Herraiz <isra@herraiz.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing
# permissions and limitations under the License.

# specs/ documents the class and the theme. Prose cannot be tested, but the
# numbers in it can: these tests read every checkable value out of the source
# and assert that the documentation still agrees. Neither side is hard-coded
# here, so the test cannot drift either.
#
# This exists because specs/product-guidelines.md once recorded page margins
# the class had never used, and nothing noticed for 27 development cycles.

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
CLS="$REPO_ROOT/ui1activity.cls"
STY="$REPO_ROOT/beamerthemeui1beamer.sty"
SPECS="$REPO_ROOT/specs"

# Every package loaded by a source file, including the multi-line
# \RequirePackage[...]{geometry} whose closing brace sits on its own line.
packages_in() {
  {
    grep -oE '\\RequirePackage(\[[^]]*\])?\{[a-z0-9-]+\}' "$1" |
      sed -E 's/.*\{([a-z0-9-]+)\}/\1/'
    grep -oE '^\]\{[a-z0-9-]+\}' "$1" | tr -d '][}{'
  } | sort -u
}

@test "cover table width in the class matches specs/cover-and-pagination.md" {
  WIDTH=$(grep -oE '\\begin\{tabularx\}\{[0-9.]+mm\}' "$CLS" |
    sed -E 's/.*\{([0-9.]+mm)\}/\1/')
  [ -n "$WIDTH" ]
  grep -q "$WIDTH" "$SPECS/cover-and-pagination.md"
}

@test "geometry margins in the class match specs/product-guidelines.md" {
  # The options sit between \RequirePackage[ and ]{geometry}.
  OPTS=$(sed -n '/\\RequirePackage\[/,/\]{geometry}/p' "$CLS" |
    grep -oE '(top|left|right|bottom|footskip)=[0-9.]+mm')
  [ -n "$OPTS" ]
  [ "$(echo "$OPTS" | wc -l)" -eq 5 ]
  for opt in $OPTS; do
    grep -q -- "$opt" "$SPECS/product-guidelines.md"
  done
}

@test "every colour defined in the class or theme is documented in specs/" {
  HEXES=$(grep -hoE '\\definecolor\{[a-z]+\}\{HTML\}\{[0-9A-F]{6}\}' "$CLS" "$STY" |
    sed -E 's/.*\{([0-9A-F]{6})\}/\1/' | sort -u)
  [ -n "$HEXES" ]
  for hex in $HEXES; do
    grep -rq "$hex" "$SPECS"
  done
}

@test "logo crop in the theme matches specs/beamer-theme.md" {
  TRIM=$(grep -oE 'trim=[0-9. bp]+bp' "$STY")
  [ -n "$TRIM" ]
  grep -qF "$TRIM" "$SPECS/beamer-theme.md"
}

@test "every image the theme includes exists in imgs/" {
  FILES=$(grep -oE '\\includegraphics(\[[^]]*\])?\{imgs/[a-z-]+(\.png)?\}' "$STY" |
    sed -E 's/.*\{(imgs\/[a-z-]+)(\.png)?\}/\1/' | sort -u)
  [ -n "$FILES" ]
  for img in $FILES; do
    # The theme writes the paths without an extension, as graphicx expects.
    [ -f "$REPO_ROOT/$img.png" ]
  done
}

@test "hyperref is the last package the class loads" {
  LAST=$(grep -oE '\\RequirePackage(\[[^]]*\])?\{[a-z0-9-]+\}' "$CLS" |
    sed -E 's/.*\{([a-z0-9-]+)\}/\1/' | tail -1)
  [ "$LAST" = "hyperref" ]
}

@test "every package the class loads is named in specs/tech-stack.md" {
  for pkg in $(packages_in "$CLS"); do
    grep -q -- "$pkg" "$SPECS/tech-stack.md"
  done
}

@test "every package the theme loads is named in specs/tech-stack.md" {
  for pkg in $(packages_in "$STY"); do
    grep -q -- "$pkg" "$SPECS/tech-stack.md"
  done
}

@test "each subsystem doc points at a source file that exists" {
  for doc in "$SPECS"/*.md; do
    grep -oE '`(ui1activity\.cls|beamerthemeui1beamer\.sty|Makefile)`' "$doc" |
      tr -d '`' | sort -u | while read -r src; do
      [ -f "$REPO_ROOT/$src" ]
    done
  done
}
