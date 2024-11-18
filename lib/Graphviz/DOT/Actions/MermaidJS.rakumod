use v6.d;

#============================================================
# The actions class
#============================================================
use Graphviz::DOT::Actions::Common;

class Graphviz::DOT::Actions::MermaidJS
        does Graphviz::DOT::Actions::Common {

    has $!vertex-count = 0;
    has %!vertex-ids;

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

    method comment($/) {
        make $/.Str.subst('//', '%%');
    }

    method node-id($/) {
        if $<quoted-string> {
            my $id = $<quoted-string>.Str;
            if %!vertex-ids{$id}:exists {
                make %!vertex-ids{$id}
            } else {
                %!vertex-ids{$id} = "v{$!vertex-count++}";
                make "{%!vertex-ids{$id}}[{ $id }]"
            }
        } else {
            make $/.Str;
        }
    }

    method node($/) {
        my $id = $<node-id>.made;
        my $attrs = '';
        if $<node-attr-list> {
            my @labels = |self.get-node-attr-value($/, 'label');
            my $shape = self.get-shape-value($/);
            if @labels {
                $attrs = "{%!shapes{$shape}.head}{ @labels.head<value>.made }{%!shapes{$shape}.tail}";
            }
        }
        make "{ $id }{ $attrs }";
    }

    method edge($/) {
        my $from = $<node-id>.made;
        my $rhs = $<edge-rhs>.made;
        my $attrs = self.get-label-value($/, 'edge');
        $attrs = $attrs ?? $attrs !! $<edge-attr-list>.made;
        $attrs = $<edge-attr-list> ?? "| {self.to-unquoted($attrs)} |" !! '';
        make $from ~ $rhs.subst('⎡⎡⎡ATTRS⎦⎦⎦', $attrs, :g);
    }

    method edge-rhs($/) {
        my $to = $<node-id>.made;
        my $rhs = $<edge-rhs>».made;
        my $op = $<edge-op>.Str eq '->' ?? '-->' !! '---';
        make " $op ⎡⎡⎡ATTRS⎦⎦⎦$to$rhs";
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
