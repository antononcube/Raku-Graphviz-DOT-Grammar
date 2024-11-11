# Graphviz::DOT::Grammar

Raku package with a parser and interpreters of Graphviz DOT language.

Languages and formats DOT is translated to:

- [X] DONE DOT layout formats
  - SVG, EPS, JSON, plain, etc. 
- [X] DONE Mermaid-JS
- [-] TODO Mathematica
  - [X] DONE Basic vertexes and edges
  - [ ] TODO Vertex styles
  - [ ] TODO Edge styles
- [X] DONE PlantUML
  - PlantUML uses DOT language, so it was very short and easy format implementation.
- [ ] TODO Raku
  - Translation to Raku graphs, [AAp1]

------

## Usage examples

Here is a graph (see [AAp1]):

```perl6
use Graph::HexagonalGrid;

my $g = Graph::HexagonalGrid.new(1, 1);
```

Translate to [Mermaid-JS]():

```perl6, output.prompt=NONE, output.language=mermaid
use Graphviz::DOT::Grammar;
$g.dot ==> dot-interpret(a=>'mermaid')
```

Translate to Mathematica:

```perl6, output.prompt=NONE,  output.language=mathematica
$g.dot ==> dot-interpret(a=>'Mathematica')
```

------

## CLI

The package provides the Command Line Interface (CLI) script `from-dot`. Here its usage message:

```shell
from-dot --help
```

------

## References 

[AAp1] Anton Antonov,
[Graph Raku package](https://github.com/antononcube/Raku-Graph),
(2024),
[GitHub/antononcube](https://github.com/antononcube).
