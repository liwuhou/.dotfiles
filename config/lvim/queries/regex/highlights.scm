; Forked from tree-sitter-regex
; The MIT License (MIT) Copyright (c) 2014 Max Brunsfeld
;
; Override of nvim-treesitter's runtime copy: line 9 matched a bare "<" node
; that the regex parser doesn't expose (regex only has "<" inside "(?<"
; lookbehind, not as a standalone node). That made the highlights query fail
; to compile with "Query error at 9:4. Invalid node type <", which surfaces
; whenever a js file's regex literal triggers regex-injection highlighting
; (e.g. telescope preview). Removed the bare "<" entry; "(?<" still captures
; the lookbehind bracket.
[
  "("
  ")"
  "(?"
  "(?:"
  "(?<"
  ">"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket
