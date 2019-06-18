(** KeyValues is a package for parsing Valve's KeyValues1 file format, used in
    the Source engine and its tooling. This is more or less a translation of my
    F# implementation because ocaml is a better language and I'm tired of messing
    with dotnet garbage.

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
    along with this program.  If not, see <https://www.gnu.org/licenses/>. *)

open Keyvalues

let () =
    print_keyvalues (test "foo bar quux asdfd [ a && b || c ]")
