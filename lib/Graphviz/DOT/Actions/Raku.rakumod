use v6.d;

#============================================================
# The actions class
#============================================================

use Graphviz::DOT::Actions::Mathematica;
use Graphviz::DOT::Actions::Retrievish;

class Graphviz::DOT::Actions::Raku
        does Graphviz::DOT::Actions::Retrievish
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

    method edge($/) {
        my $from = $<node-id>[0].Str;
        my $to = $<node-id>[1].Str;
        my $directed = $<edge-op>.Str eq '--' ?? ':!directed' !! ':directed';
        my $weight = self.get-weight-value($/);
        make Pair.new('edge', $weight ?? "\{from => $from, to => $to, weight => $weight, $directed\}" !! "$from => $to");
    }
}