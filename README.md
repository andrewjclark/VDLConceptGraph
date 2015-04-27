# VDLConceptGraph
A Swift class that maps the relationships between concepts, as defined in a human readable text file.

Concepts and their relationships are defined in the file ConceptIndex.conceptindex. Concept definitions take the form: ConceptID RelatedConceptID,etc ImageName,etc

When defining the concept ANIMAL and that it is related to SNAKE, MONKEY and LION we type the following (note the single space between ANIMAL and SNAKE)
ANIMAL SNAKE,MONKEY,LION

To define the images that represent the concept LION we type the following (note the double space since we are not defining related concepts)
LION  lion1.png, lion2.png

A concept can be related to other concepts whilst also having it's own images:
ZOO ANIMAL zoo-gate.png,zoo-sign.png

Example usage:

```
let conceptGraph = VDLConceptGraph.sharedInstance
println("\(conceptGraph)")
        
let probabilitySet = conceptGraph.probabilitySetForConceptWithUid("ZOO", requireImages: false)
println("\nProbability set for ZOO without requiring images: \(probabilitySet)");
```

Enjoy!

