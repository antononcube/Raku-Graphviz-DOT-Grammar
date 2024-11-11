use v6.d;

#============================================================
# Common actions role
#============================================================

role Graphviz::DOT::Actions::Common {

    method to-quoted($arg) {
        return "\"{$arg.Str}\"".subst(/ ^ \"+ | \"+ $ /, '"'):g;
    }

    method get-node-attr-value($/, Str:D $attr) {
        return $<node-attr-list>.values>><attr-pair>.flat.grep({ $_<identifier> eq $attr });
    }

    method get-edge-attr-value($/, Str:D $attr) {
        return $<edge-attr-list>.values>><attr-pair>.flat.grep({ $_<identifier> eq $attr });
    }

    method get-shape-value($/) {
        my @shapes = |self.get-node-attr-value($/, 'shape');
        my $shape = 'box';
        if @shapes {
            $shape = @shapes.head<value>.made;
            # This Mermaid JS only!!
            if self.shapes{$shape}:!exists {
                $shape = 'box'
            }
        }
        return $shape;
    }

    method get-weight-value($/) {
        my @weights = |self.get-edge-attr-value($/, 'weight');
        my $weight = Whatever;
        if @weights { $weight = @weights.head<value>.made; }
        make $weight;
    }
}
