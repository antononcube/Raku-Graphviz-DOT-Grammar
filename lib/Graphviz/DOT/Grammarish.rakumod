use v6.d;

role Graphviz::DOT::Grammarish {
    rule TOP             { <graph> }
    regex graph          { [<strict> \h*]? <type> [<id> \h*]? \s* '{' \s* <stmt-list> \s* '}' \s* }
    token stmt-sep       {';'}
    token strict         { 'strict' }
    token type           { 'graph' | 'digraph' }
    token id             { <identifier> }
    regex stmt-list      { <stmt>* % [\s* [ <stmt-sep> | \v ] \s*] }
    regex stmt           { <node> | <edge> | <attribute> | <subgraph> | <assignment> | <comment> }
    regex comment        { ^^ \h* '//' <-[\v]>* }
    regex node           { <node-id> [\h* <node-attr-list>]? }
    regex edge           { <node-id> \h* <edge-rhs> [\h+ <edge-attr-list>]? \s* <stmt-sep>?}
    regex edge-rhs       { <edge-op> \h* <node-id> [\h* <edge-rhs>]* }
    token edge-op        { '--' | '->' }
    regex attribute      { <attr-type> \h+ <attr-list> }
    token attr-type      { 'graph' | 'node' | 'edge' }
    regex attr-list      { '[' \h* <attr-pair>+ % [\h* ',' \h*] \h* ']' }
    rule attr-pair       { <identifier> '=' <value> }
    regex node-id        { <identifier> | <quoted-string> }
    regex edge-attr-list { <attr-list> }
    regex node-attr-list { <attr-list> }
    regex subgraph       { 'subgraph' [\s* <id>?] \s* '{' \s* <stmt-list> \s* '}' }
    regex assignment     { <identifier> \h* '=' \h* <value> \s* <stmt-sep>?}
    token identifier     { [ \w | \d | _]+ }
    token value          { <identifier> | <quoted-string> }
    token quoted-string  { '"' <-["]>+ '"' }
}