open Core_extended.Logger

let logger = ref (create_default "")

let enabled = ref 0
let indented_sep (indent : int) = "\n" ^ (Core.String.make (42 + indent) ' ')

let fatal lstr = if !enabled > 0 then log (!logger) (`Fatal , (Lazy.force lstr)) else ()
let error lstr = if !enabled > 1 then log (!logger) (`Error , (Lazy.force lstr)) else ()
let warn  lstr = if !enabled > 2 then log (!logger) (`Warn  , (Lazy.force lstr)) else ()
let info  lstr = if !enabled > 3 then log (!logger) (`Info  , (Lazy.force lstr)) else ()
let debug lstr = if !enabled > 4 then log (!logger) (`Debug , (Lazy.force lstr)) else ()

let disable () = enabled := 0

let enable ?(msg = "") ?(level = 5) (file : string) =
  logger := create_default file ;
  clear_filter (!logger) ;
  enabled := level ;
  info (lazy "") ;
  info (lazy (msg ^ "========================================"))