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
```
# Graph(vertexes => 6, edges => 6, directed => False)
```

Translate to [Mermaid-JS]():

```perl6, output.prompt=NONE, output.language=mermaid
use Graphviz::DOT::Grammar;
$g.dot ==> dot-interpret(a=>'mermaid')
```
```mermaid
graph TB
v0["0"]
v1["3"]
v2["1"]
v3["5"]
v4["4"]
v5["2"]
v2 --- v1
v0 --- v2
v0 --- v5
v5 --- v4
v1 --- v3
v4 --- v3
```

Translate to Mathematica:

```perl6, output.prompt=NONE,  output.language=mathematica
$g.dot ==> dot-interpret(a=>'Mathematica')
```
```mathematica
Graph[{}, {UndirectedEdge["1", "3"], UndirectedEdge["0", "1"], UndirectedEdge["0", "2"], UndirectedEdge["2", "4"], UndirectedEdge["3", "5"], UndirectedEdge["4", "5"]}]
```

------

## References 

[AAp1] Anton Antonov,
[Graph Raku package](https://github.com/antononcube/Raku-Graph),
(2024),
[GitHub/antononcube](https://github.com/antononcube).
