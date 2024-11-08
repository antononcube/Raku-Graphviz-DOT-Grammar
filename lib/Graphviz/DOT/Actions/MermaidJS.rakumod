use v6.d;

#============================================================
# The actions class
#============================================================

class Graphviz::DOT::Actions::MermaidJS {

    #======================================================
    # General
    #======================================================
    has %!shapes =
            box => <( )>,
            circle => <(( ))>,
            doublecircle => <((( )))>,
            square => <[ ]>,
            rect => <[ ]>,
            rectangle => <[ ]>,
            parallelogram => <[/ /]>,
            trapezium => <[/ \]>,
            invtrapezium => <[\ /]>,
            oval => <([ ])>,
            ellipse => <([ ])>,
            note => ['>', ']'],
            diamond => <{ }>,
            polygon => <{{ }}>,
            hexagon => <{{ }}>,
            cylinder => <[( )]>
            ;

    method get-attr-value($/, Str:D $attr) {
        return $<node-attr-list>.values>><attr-pair>.flat.grep({ $_<identifier> eq $attr });
    }

    method get-shape-value($/) {
        my @shapes = |self.get-attr-value($/, 'shape');
        my $shape = 'box';
        if @shapes {
            $shape = @shapes.head<value>.made;
            if %!shapes{$shape}:!exists {
                $shape = 'box'
            }
        }
        return $shape;
    }

    #======================================================
    # Grammar methods
    #======================================================
    method TOP($/) {
        make $<graph>.made;
    }

    method graph($/) {
        my $type = $<type>.Str eq 'digraph' ?? 'flowchart TD' !! 'graph TB';
        my $id = $<id> ?? $<id>.Str ~ ' ' !! '';
        make "$type\n" ~ $<stmt-list>.made;
    }

    method stmt-list($/) {
        make $<stmt>».made.join("\n");
    }

    method stmt($/) {
        make $/.values.first.made;
    }

    method node($/) {
        my $id = $<node-id>.Str;
        my $attrs = '';
        if $<node-attr-list> {
            my @labels = |self.get-attr-value($/, 'label');
            my $shape = self.get-shape-value($/);
            if @labels {
                $attrs = "{%!shapes{$shape}.head}{ @labels.head<value>.made }{%!shapes{$shape}.tail}";
            }
        }
        make "{ $id }{ $attrs }";
    }

    method edge($/) {
        my $from = $<node-id>[0].Str;
        my $to = $<node-id>[1].Str;
        my $op = $<edge-op>.Str eq '->' ?? '-->' !! '---';
        my $attrs = $<edge-attr-list> ?? "|{ $<edge-attr-list>.made }|" !! '';
        make "$from $op $attrs $to";
    }

    method attribute($/) {
        # Attributes are not directly translatable to Mermaid-JS, so we ignore them
        make '';
    }

    method subgraph($/) {
        my $id = $<id> ?? $<id>.Str ~ ' ' !! '';
        make "subgraph $id\n" ~ $<stmt-list>.made.subst(/^^/, "\t", :g) ~ "\nend\n";
    }

    method assignment($/) {
        # Assignments are not directly translatable to Mermaid-JS, so we ignore them
        make '';
    }

    method node-attr-list($/) {
        make $<attr-list>.made;
    }

    method edge-attr-list($/) {
        make $<attr-list>.made;
    }

    method attr-list($/) {
        make $<attr-pair>».made;
    }

    method attr-pair($/) {
        make $<identifier>.Str ~ '=' ~ $<value>.Str;
    }

    method identifier($/) {
        make ~$/;
    }

    method value($/) {
        make ~$/;
    }

    method quoted-string($/) {
        make ~$/;
    }
}
