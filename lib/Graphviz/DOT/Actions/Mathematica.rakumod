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
        my $vs = %stmts<vertex-style> ?? "VertexStyle -> {%stmts<vertex-style>}" !! '';
        make 'Graph[' ~ [ %stmts<vertexes>, %stmts<edges>, $vs, %stmts<global>].grep(*.so).join(', ') ~ ']';
    }

    method stmt-list($/) {
        my @res = $<stmt>>>.made.flat;
        my @edges = @res.grep({ $_ ~~ Pair:D && $_.key eq 'edge' });
        my @vertexes = @res.grep({ $_ ~~ Pair:D && $_.key eq 'vertex' });
        my @styles = @res.grep({ $_ ~~ Pair:D && $_.key eq 'vertex-style' });
        my @global = @res.grep({ $_ ~~ Str:D && $_.starts-with('label') }).map({ $_.subst(/^ label/, 'PlotLabel')});
        make %(
            vertexes => '{' ~ @vertexes>>.value.join(', ') ~ '}',
            edges => '{' ~ @edges>>.value.join(', ') ~ '}',
            vertex-style => @styles ?? '{' ~ @styles>>.value.join(', ') ~ '}' !! '',
            :@global
        );
    }

    method stmt($/) {
        make $/.values[0].made;
    }

    method comment($/) {
        make $/.Str.subst('//', '(*') ~ "*)\n";
    }

    method node-id($/) {
        make $/.Str;
    }

    method node($/) {
        my $id = $<node-id>.Str;
        my $attrs = $<node-attr-list> ?? $<node-attr-list>.made !! '';
        make (Pair.new('vertext', $id), $attrs ?? Pair.new('vertex-style', "$id -> $attrs") !! Empty);
    }

    method edge($/) {
        my $from = $<node-id>.Str;
        my @rhs = $<edge-rhs>.made;
        my $attrs = $<edge-attr-list> ?? $<edge-attr-list>.made !! '';
        my @res = [$from, |@rhs];
        note @res;
        @res = @res.rotor(3=>-1).map({
            if $attrs {
                "{ $_[1] }\[{ $_[0] }, { $_[2] }, $attrs\]"
            } else {
                "{ $_[1] }\[{ $_[0] }, { $_[2] }\]"
            }
        });
        my $res = @res.join(', ');
        make Pair.new('edge', $res);
    }

    method edge-rhs($/) {
        my $to = $<node-id>.made;
        my @rhs = |$<edge-rhs>».made;
        my $op = $<edge-op>.Str eq '--' ?? 'UndirectedEdge' !! 'DirectedEdge';
        make @rhs ?? [$op, $to, |@rhs.map(*.Slip)] !! [$op, $to];
    }

    method attribute($/) {
        my $type = $<attr-type>.Str;
        my $attrs = $<attr-list>.made;
        make "$type -> \{ $attrs \}";
    }

    method node-attr-list($/) {
        make $<attr-list>.made;
    }

    method edge-attr-list($/) {
        make $<attr-list>.made;
    }

    method attr-list($/) {
        make $<attr-pair>.map(*.made).join(', ');
    }

    method attr-pair($/) {
        make "{$<identifier>.Str} -> {$<value>.Str}";
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