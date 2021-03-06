(*
Module: NetworkManager
  Parses /etc/NetworkManager/system-connections/* files which are GLib
  key-value setting files.

Author: Raphael Pinson <raphael.pinson@camptocamp.com>

About: License
   This file is licenced under the LGPL v2+, like the rest of Augeas.

About: Lens Usage
   To be documented

About: Configuration files
   This lens applies to /etc/NetworkManager/system-connections/*. See <filter>.

About: Examples
   The <Test_NetworkManager> file contains various examples and tests.
*)

module NetworkManager =
autoload xfm

(************************************************************************
 * INI File settings
 *
 * GLib only supports "# as commentary and "=" as separator
 *************************************************************************)
let comment    = IniFile.comment "#" "#"
let sep        = Sep.equal
let eol        = Util.eol

(************************************************************************
 *                        ENTRY
 * GLib entries can contain semicolons, entry names can contain spaces and
 * brackets
 *************************************************************************)
(* Variable: entry_re *)
let entry_re   = /[A-Za-z][A-Za-z0-9._\(\) \t-]+/

(*
Variable: to_comment_re
  Regex until comment allowing semicolons
*)
let to_comment_re = /[^"# \t\n][^"#\n]*[^"# \t\n]|[^"# \t\n]/
                  | /"[^\n"]*"/

let entry   = [ key entry_re . sep
                . (store to_comment_re)? . (comment|eol) ] | comment

(************************************************************************
 *                        RECORD
 * GLib uses standard INI File records
 *************************************************************************)
let title   = IniFile.indented_title IniFile.record_re
let record  = IniFile.record title entry


(************************************************************************
 *                        LENS & FILTER
 * GLib uses standard INI File records
 *************************************************************************)
let lns     = IniFile.lns record comment

(* Variable: filter *)
let filter = incl "/etc/NetworkManager/system-connections/*"

let xfm = transform lns filter
