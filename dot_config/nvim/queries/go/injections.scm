;extends
;sql
; SQL syntax highlighting within strings (NVIM v0.9.4)
(
    [
        (raw_string_literal)
        (interpreted_string_literal)
    ] @injection.content
    (#match? @injection.content "(SELECT|INSERT|UPDATE|DELETE).+(FROM|INTO|VALUES|SET).*(WHERE|GROUP BY)?")
    (#set! injection.language "sql")
)

(field_declaration
  tag: (raw_string_literal
    (raw_string_literal_content) @injection.content
    (#set! injection.self)
  ))
