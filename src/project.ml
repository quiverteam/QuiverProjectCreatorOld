(** Quiver Project Creator (or QPC) is a build tool inspired by Valve's VPC.
    This repository contains both the QPC source code, and the KV1 parser
    on which it depends. This source file is part of QPC, and is unrelated
    to the KV1 parser.

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
open Kvmap
open Base

type lang = Cpp
          | C

type compile_type = Static
                  | Dynamic

type executable = {
    sources   : string list;
    aux_files : string list;
    deps      : string list;
}

type library = {
    lib_type      : compile_type;
    lib_sources   : string list;
    lib_aux_files : string list;
    lib_deps      : string list;
}

type executables = (string, executable, String.comparator_witness) Map.t
type libraries   = (string, library,    String.comparator_witness) Map.t

type project = {
    root     : string;
    language : lang;
    execs    : executables;
    libs     : library list;
}
