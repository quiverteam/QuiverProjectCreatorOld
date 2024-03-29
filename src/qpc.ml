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


let version = "0.1.0"

let to_test = (kvmap_of_syntax (test "hello world") [])
let exec_test = kvmap_of_syntax (test "executable foo { bar baz }") []

let () =
    print_endline ("QPC v" ^ version);
    (* should be world *)
    print_endline (get_string_or_die to_test "hello" "key `hello` not found!");
    (* should be `foo` *)
    print_endline
        (get_string_or_die
            (get_block_or_die
                exec_test
                "executable"
                "exec not found")
            "__name__"
            "__name__ not found");
    ()
