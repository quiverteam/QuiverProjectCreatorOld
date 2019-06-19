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
open Base

(** [value] is the OCaml representation of a value in a KeyValue file, not to
    be confused with [value'] which is the parser's representation of one,
    which is much lower level and should not be used other than to create this.
    
    String values are organized in reverse chronological order or LI-FO. This
    means that the first occurance of a value assigned to a key in a certain
    block will be the last to be read from the Str variant, and at the end of
    the [string list]. *)
type value = Str of string
           | Block of kvmap

(** [kvmap] is the type of the interal OCaml representation of KeyValues, not as
    an AST like the one the parser creates, but rather as a map that can be
    easily used by other functions *)
and kvmap = (string, value list, String.comparator_witness) Map.t

let empty = Map.empty (module String)

let insert (map : kvmap) k v : kvmap =
    let data = match Map.find map k with
        | Some x -> x @ [v]
        | None -> [v] in
    Map.set map ~key:k ~data:data

let get_all map k = Map.find map k

(** [get_one] is useful for extracting a value that is meant to be declared
    exactly once in the KeyValues. It returns [Some value] if it is found
    exactly once, [None] otherwise. *)
let get_one map k : value option = match Map.find map k with
    | None -> None
    | Some (x :: _) -> Some x
    | Some [] -> None

(** [bool_of_condition] evaluates a condition in a given context.
    @argument [string list] defined
    @argument [condition] conditions *)
let rec bool_of_condition def = function
    | And (a, b) -> (bool_of_condition def a) && (bool_of_condition def b)
    | Or (a, b)  -> (bool_of_condition def a) || (bool_of_condition def b)
    | Not a      -> not (bool_of_condition def a)
    | Defined a  -> List.exists def ~f:(String.equal a)
    | Empty      -> true

let rec kvmap_of_syntax s def : kvmap = match s with
    | [] -> empty
    | (k, v, c) :: xs -> match bool_of_condition def c with
        | false -> kvmap_of_syntax xs def
        | true  ->
            let map = kvmap_of_syntax xs def in
            insert map k (match v with
                | Str' a -> Str a
                | Block' a -> Block (kvmap_of_syntax a def)
            )
