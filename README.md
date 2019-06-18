# Quiver Project Creator

[![Build Status](https://img.shields.io/azure-devops/build/quiverteam/be22e09b-4923-4f7c-b6d1-dd62114628d3/3.svg?style=flat-square)](https://dev.azure.com/quiverteam/QuiverProjectCreator)

## Example

This is an example of what a QPC build script would look like once this is
finished. This syntax was decided on by myself and other developers working
on Quiver related projects.

```c
language cpp

#define SRCDIR "../../"
#include "$SRCDIR/game/client/client_base.qpc"

executable {
    name some_game
    include (
        hl2r
        hl2
        "$SRCDIR/game/shared/hl2"
        "$SRCDIR/game/shared/episodic"
        ../../public
        "$BASE"
    )
    file sauce.cpp
    header linux.h [LINUX]
    header shitshow.h [WINDOWS]

    dynamic tier0
    dynamic tier1
    // imagine using boost in source lmao
    static boost
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
