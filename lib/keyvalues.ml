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

open Angstrom

(** The value type is either a string in the form of a KV double-quoted string
    or identifier, or a block, containing a child syntax tree *)
type value    = String of string
              | Block of syntax

(** The condition type represents a set of conditions that must be met in order
    for the previous key-value pair to be included. Empty always evaluates to
    true, and Defined checks if the string it takes has been defined in some
    context. The other options are simply combinations of these. *)
and condition = And of condition * condition
              | Or of condition * condition
              | Not of condition
              | Defined of string
              | Empty

(** A node is a single key-value pair. Syntactically it looks like this
    [key value \[CONDITION && ANOTHER_COND || YET_ANOTHER\]] *)
and node      = string * value * condition

(** syntax is just a list of nodes. It's that simple. *)
and syntax    = node list

(** Shamelessly stolen from the Angstrom readme, it does what I need so why
    change it? *)
let chainl1 ex op =
    let rec go acc =
        (lift2 (fun op ex -> op acc ex) op ex >>= go) <|> return acc in
    ex >>= fun init -> go init

(** Is the character a whitespace char? *)
let is_space = function
    | ' ' | '\t' | '\r' | '\n' -> true
    | _ -> false

(** Take zero or more spaces, including newlines *)
let spaces = take_while is_space

(* This is definitely not following DRY, should optimize this a bit later. *)
let braces p   = char '{' *> spaces *> p <* char '}'
let brackets p = char '[' *> spaces *> p <* char ']'
let parens p   = char '(' *> spaces *> p <* char ')'

(** Is the character a valid identifier? Used with take_while *)
let is_ident = function
    | 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '$' | '|' | '%' | '@' | ':' | '.'
    | '/' | '\\' -> true
    | _ -> false

(** An unquoted identifier *)
let ident = (take_while1 is_ident) <* spaces

(** Can this character be in a string? Anything but newlines and quotes is true *)
let is_string = function
    | '"' | '\r' | '\n' -> false
    | _ -> true

(** A double-quoted string literal, no escaping yet. *)
let string' = char '"' *> take_while is_string <* char '"'

let key_or_value = string' <|> ident

let and' = string "&&" *> spaces *> return (fun a b -> And (a, b))
let or' = string "||" *> spaces *> return (fun a b -> Or (a, b))
let def = ident >>| (fun x -> Defined x)

(** An expression is a set of conditions that are evaluated *)
let expression = fix (fun expr ->
    let fact = parens expr <|> def in
    chainl1 fact (and' <|> or'))

(** The top-level parser, parses a bunch of keyvalues recursively *)
let tl = fix (fun (top: node list t) ->
    let block     = braces top   >>| fun x -> Block x in
    let val_str   = key_or_value >>| fun x -> String x in
    let value'    = (val_str <|> block)   <* spaces in
    let cond      = (brackets expression) <* spaces in
    let pair_cond = lift3 (fun k v c : node -> k, v, c)
                          key_or_value value' cond in
    let pair      = lift2 (fun k v : node -> k, v, Empty)
                          key_or_value value' in
    many (pair_cond <|> pair))

(** Test function for debugging *)
let test (s: string) = match parse_string tl s with
    | Ok r -> r
    | Error msg -> failwith msg

(** Auxiliary function for condition printing, should not be used explicitly. *)
let rec print_condition' = function
    | And (a, b) ->
        print_string "(";
        print_condition' a;
        print_string ") && (";
        print_condition' b;
        print_string ")"
    | Or (a, b) ->
        print_string "(";
        print_condition' a;
        print_string ") || (";
        print_condition' b;
        print_string ")"
    | Defined a -> print_string a
    | _ -> print_string "_"

(** Debug function that pretty-prints a condition recursively *)
let print_condition s =
    print_string " [ ";
    print_condition' s;
    print_string " ] "

(** Debug function that pretty-prints keyvalues *)
let rec print_keyvalues a = match a with
    | [] -> ()
    | x :: xs -> (match x with
        | s, String v, c ->
            print_string s;
            print_string " ";
            print_string v;
            print_condition c
        | s, Block v, c ->
            print_string s;
            print_string " { ";
            print_keyvalues v;
            print_string " } ";
            print_condition c
        );
        print_keyvalues xs
