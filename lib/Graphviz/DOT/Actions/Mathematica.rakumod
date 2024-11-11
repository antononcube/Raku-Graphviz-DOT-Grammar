use v6.d;

#============================================================
# The actions class
#============================================================

class Graphviz::DOT::Actions::Mathematica {
    method TOP($/) {
        make $<graph>.made;
    }

    method graph($/) {
        #my $strict = $<strict> ?? 'True' !! 'False';
        #my $type = $<type>.Str eq 'graph' ?? 'UndirectedEdge' !! 'DirectedEdge';
        #my $id = $<id> ?? $<id>.Str !! 'graph';
        my %stmts = $<stmt-list>.made;
        my $vs = %stmts<vertex-style> ?? "VertexStyle -> {%stmts<vertex-style>}," !! '';
        make "Graph\[{%stmts<vertexes>}, {%stmts<edges>}, $vs VertexLabels -> \"Name\"\]";
    }

    method stmt-list($/) {
        my @res = $<stmt>>>.made;
        my @edges = @res.grep({ $_ ~~ Pair:D && $_.key eq 'edge' });
        my @vertexes = @res.grep({ $_ ~~ Pair:D && $_.key eq 'vertex' });
        my @styles = @res.grep({ $_ ~~ Pair:D && $_.key eq 'vertex-style' });
        make %(
            vertexes => '{' ~ @vertexes>>.value.join(', ') ~ '}',
            edges => '{' ~ @edges>>.value.join(', ') ~ '}',
            vertex-style => @styles ?? '{' ~ @styles>>.value.join(', ') ~ '}' !! '',
        );
    }

    method stmt($/) {
        make $/.values[0].made;
    }

    method node($/) {
        my $id = $<node-id>.Str;
        my $attrs = $<node-attr-list> ?? $<node-attr-list>.made !! '';
        make (Pair.new('vertext', $id), $attrs ?? Pair.new('vertex-style', "$id -> $attrs") !! Empty);
    }

    method edge($/) {
        my $from = $<node-id>[0].Str;
        my $to = $<node-id>[1].Str;
        my $op = $<edge-op>.Str eq '--' ?? 'UndirectedEdge' !! 'DirectedEdge';
        my $attrs = $<edge-attr-list> ?? $<edge-attr-list>.made !! '';
        make Pair.new('edge', $attrs ?? "$op\[$from, $to, $attrs\]" !! "$op\[$from, $to\]");
    }

    method attribute($/) {
        my $type = $<attr-type>.Str;
        my $attrs = $<attr-list>.made;
        make "$type -> \{ $attrs \}";
    }

    method attr-list($/) {
        make $<attr-pair>.map(*.made).join(', ');
    }

    method attr-pair($/) {
        make "$<identifier>.Str -> $<value>.Str";
    }

    method subgraph($/) {
        my $id = $<id>.Str ?? $<id>.Str !! 'subgraph';
        my $stmts = $<stmt-list>.map(*.made).join(', ');
        make "Subgraph[$id, { $stmts }]";
    }

    method assignment($/) {
        make "{$<identifier>.Str} -> {$<value>.Str}";
    }

    method identifier($/) {
        make $/.Str;
    }

    method value($/) {
        make $/.Str;
    }

    method quoted-string($/) {
        make $/.Str;
    }
}