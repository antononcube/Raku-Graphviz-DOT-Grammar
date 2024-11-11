use v6.d;

#============================================================
# Graphviz actions class
#============================================================

class Graphviz::DOT::Actions::Layout {

    has $.format = 'svg';
    has $.engine = 'dot';

    method !dot-svg($input, Str:D :$engine = 'dot', Str:D :$format = 'svg') {
        my $temp-file = $*TMPDIR.child("temp-graph.dot");
        $temp-file.spurt: $input;
        my $svg-output = run($engine, $temp-file, "-T$format", :out).out.slurp-rest;
        unlink $temp-file;
        return $svg-output;
    }

    method TOP($/) {
        make self!dot-svg($/.Str, :$!engine, :$!format);
    }
}
