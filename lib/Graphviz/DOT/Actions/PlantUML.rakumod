use v6.d;

#============================================================
# PlantUML actions class
#============================================================

class Graphviz::DOT::Actions::PlantUML {
    method TOP($/) {
        make ['@startuml', $/.Str, '@enduml'].join("\n");
    }
}

