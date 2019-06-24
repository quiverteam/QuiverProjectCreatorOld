# Quiver Project Creator

[![Build Status](https://img.shields.io/azure-devops/build/quiverteam/be22e09b-4923-4f7c-b6d1-dd62114628d3/3.svg?style=flat-square)](https://dev.azure.com/quiverteam/QuiverProjectCreator)

## Example

This is an example of what a QPC build script would look like once this is
finished. This syntax was decided on by myself and other developers working
on Quiver related projects.

```c
// main.qpc
language cpp

// import the other sub project
import lib/bar.qpc

// create an executable called foo
executable foo {
    source foo.cpp
    source main.cpp
    // this is a `file`, used to check if the recipe is fresh, but not given
    // to the compiler itself
    file foo.h

    dependency bar
}

// lib/bar.qpc
language cpp

// the current directory will be included (`-I` flag)
include .

library bar {
    source bar.cpp
    file bar.hpp

    // static || dynamic
    type static

    // dependency found via. native package configurator
    // e.g: `pkg-config` on linux, windows prob has something like this.
    dependency gtk+-3.0
}
```

## License

```
KeyValues text format parser library for OCaml
Copyright (C) 2019  swissChili

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```
