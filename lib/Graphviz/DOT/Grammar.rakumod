use v6.d;

use Graphviz::DOT::Grammarish;
use Graphviz::DOT::Actions::Layout;
use Graphviz::DOT::Actions::Mathematica;
use Graphviz::DOT::Actions::MermaidJS;
use Graphviz::DOT::Actions::PlantUML;

grammar Graphviz::DOT::Grammar
        does Graphviz::DOT::Grammarish {
}

#-----------------------------------------------------------
our sub dot-subparse(Str:D $command, Str:D :$rule = 'TOP') is export {
    my $ending = $command.substr(*- 1, *) eq "\n" ?? '' !! "\n";
    Graphviz::DOT::Grammar.subparse($command ~ $ending, :$rule);
}

our sub dot-parse(Str:D $command, Str:D :$rule = 'TOP') is export {
    my $ending = $command.substr(*- 1, *) eq "\n" ?? '' !! "\n";
    Graphviz::DOT::Grammar.parse($command ~ $ending, :$rule);
}

our sub dot-interpret(Str:D $command,
                      Str:D :$rule = 'TOP',
                      :$actions is copy = Graphviz::DOT::Actions::MermaidJS.new
                      ) is export {
    # Choose actions class
    $actions = do given $actions {
        when $_ ~~ Str:D && $_.lc ∈ ["mathematica", "wl", "wolfram language"] {
            Graphviz::DOT::Actions::Mathematica.new
        }
        when $_ ~~ Str:D && $_.lc ∈ <mermaid mermaid-js> {
            Graphviz::DOT::Actions::MermaidJS.new
        }
        when $_ ~~ Str:D && $_.lc ∈ <plantuml> {
            Graphviz::DOT::Actions::PlantUML.new
        }
        when $_ ~~ Str:D && $_.lc ∈ <dot svg svgz json plain plain-ext ps eps fig vml> {
            Graphviz::DOT::Actions::Layout.new(format => $_.lc)
        }
        default {
            $actions
        }
    }

    # Result
    return Graphviz::DOT::Grammar.parse($command, :$rule, :$actions).made;
}

