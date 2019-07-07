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


open Kvmap
open Base

type lang = Cpp
          | C

type compile_type = Static
                  | Dynamic

(*  executable foo {
        file foo.cpp
        file bar.cpp
        file header.h

        dependency bar
    } *)
type executable = {
    name      : string;
    files     : string list;
    deps      : string list;
}

(*  library bar {
        file bar.cpp
        file header.h
    } *)
type library = {
    lib_name  : string;
    lib_type  : compile_type;
    lib_files : string list;
    lib_deps  : string list;
}

type executables = (string, executable, String.comparator_witness) Map.t
type libraries   = (string, library,    String.comparator_witness) Map.t

type project = {
    root     : string;
    language : lang;
    execs    : executables;
    libs     : libraries;
}

let executable_of_values e = {
    name = get_string_or_die e "__name__" "executable must be a named block";
    files = (match get_all e "file" with
        | Some a -> all_strings [] a
        | None -> []
        );
    deps = [];
}

let map_of_execs a =
    let execs = List.map ~f:executable_of_values (all_blocks [] a) in
    let insert_executable m k v = 
        let data = match Map.find m k with
            | Some x -> x
            | None -> v in
        Map.set m ~key:k ~data:data in
    let rec to_map acc e : executables = match e with
        | [] -> acc
        | x :: xs -> to_map (insert_executable acc x.name x) xs in
    to_map empty execs

let project_of_kvmap (m : kvmap) root = {
    root = root;
    language = (match get_one m "language" with
        | Some (Str l) -> (match l with
            | "c"
            | "C" -> C
            | _ -> Cpp)
        | _ -> Cpp
        );
    execs = (match get_all m "executables" with
        | None -> empty
        | Some a -> map_of_execs a);
    libs = empty;
}

let show_language = function
    | Cpp -> "cpp"
    | C -> "c"

let print_project p =
    Caml.print_endline ("language " ^ show_language p.language);
    Caml.print_endline ("root " ^ p.root);
    ();
