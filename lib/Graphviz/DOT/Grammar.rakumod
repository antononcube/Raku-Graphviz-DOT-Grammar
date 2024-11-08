use v6.d;

use Graphviz::DOT::Grammarish;
use Graphviz::DOT::Actions::Mathematica;
use Graphviz::DOT::Actions::MermaidJS;

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
                      :$actions = Graphviz::DOT::Actions::MermaidJS.new) is export {
    my $ending = $command.substr(*- 1, *) eq "\n" ?? '' !! "\n";
    return Graphviz::DOT::Grammar.parse($command ~ $ending, :$rule, :$actions).made;
}

