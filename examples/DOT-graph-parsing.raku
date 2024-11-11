
use lib <. lib>;
use Graphviz::DOT::Grammar;

my $graph = q:to/END/;
digraph { a -> b }
END

#say dot-parse($graph);
say $graph;

say "-" x 100;

say dot-interpret($graph);

say "-" x 100;

say dot-interpret($graph, actions => 'mathematica');

#====================================================================================================
say "=" x 100;

my $graph2 = q:to/END/;
digraph {
    label = "First";
    a -> b;
    b -> c;
    c -> a;
}
END

#say dot-parse($graph2);
say $graph2;

say "-" x 100;

say dot-interpret($graph2);

say "-" x 100;

say dot-interpret($graph2, actions => 'mathematica');

say "-" x 100;

say dot-interpret($graph2, actions => 'plain');

#====================================================================================================
say "=" x 100;

my $graph3 = q:to/END/;
graph {
  label="Vincent van Gogh Paintings"

  subgraph cluster_self_portraits {
    label="Self-portraits"

    spwgfh [label="Self-Portrait with Grey Felt Hat"]
    spaap [label="Self-Portrait as a Painter"]
  }

  subgraph cluster_flowers {
    label="Flowers"

    sf [label="Sunflowers"]
    ab [label="Almond Blossom"]
  }
}
END

#say dot-parse($graph3);
say $graph3;

say "-" x 100;

say dot-interpret($graph3);

say "-" x 100;

say dot-interpret($graph3, actions => 'mathematica');

