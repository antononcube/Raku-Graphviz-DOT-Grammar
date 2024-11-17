use v6.d;

#============================================================
# The actions class
#============================================================

use Graphviz::DOT::Actions::Mathematica;
use Graphviz::DOT::Actions::Common;

class Graphviz::DOT::Actions::Raku
        does Graphviz::DOT::Actions::Common
        is Graphviz::DOT::Actions::Mathematica {

    method TOP($/) {
        make $<graph>.made;
    }

    method graph($/) {
        my $directed = $<type>.Str eq 'graph' ?? ':!directed' !! ':directed';
        my %stmts = $<stmt-list>.made;
        %stmts<vertexes> = %stmts<vertexes>:exists ?? '[' ~ %stmts<vertexes>.substr(1, *-1) ~ ']' !! '[]';
        %stmts<edges> = %stmts<edges>:exists ?? '[' ~ %stmts<edges>.substr(1, *-1) ~ ']' !! '[]';
        make "Graph.new({%stmts<vertexes>}, {%stmts<edges>}, $directed)";
    }

#    method edge($/) {
#        my $from = self.to-quoted: $<node-id>[0].Str;
#        my $to = self.to-quoted: $<node-id>[1].Str;
#        my $directed = $<edge-op>.Str eq '--' ?? ':!directed' !! ':directed';
#        my $weight = self.get-weight-value($/);
#        make Pair.new('edge', $weight ?? "\{from => $from, to => $to, weight => $weight, $directed\}" !! "$from => $to");
#    }
    method edge($/) {
        my $from = $<node-id>.Str;
        my @rhs = $<edge-rhs>.made;
        my @res = [$from, |@rhs];
        my $weight = self.get-weight-value($/);
        @res = @res.rotor(3=>-1).map({
            if $weight {
                "\{from => {$_[0] }, to => { $_[2] }, weight => $weight, { $_[1] }\}"
            } else {
                "\{from => {$_[0] }, to => { $_[2] }, { $_[1] }\}"
            }
        });
        my $res = @res.join(', ');
        make Pair.new('edge', $res);
    }

    method edge-rhs($/) {
        my $to = $<node-id>.made;
        my @rhs = |$<edge-rhs>».made;
        my $op = $<edge-op>.Str eq '--' ?? ':!directed' !! ':directed';
        make @rhs ?? [$op, $to, |@rhs.map(*.Slip)] !! [$op, $to];
    }
}