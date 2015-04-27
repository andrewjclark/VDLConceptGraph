//
//  VDLConceptProbabilitySet.swift
//  Voidology Concept Web
//
//  Created by Andrew J Clark on 20/04/2015.
//  Copyright (c) 2015 Andrew J Clark. All rights reserved.
//

import Foundation

public class VDLConceptProbabilitySet: Printable {
    
    var conceptDictionary = Dictionary<VDLConceptObject, Double>()
    
    public func insertConcept(concept: VDLConceptObject, probability: Double) {
        conceptDictionary[concept] = probability
    }
    
    public func count() -> Int {
        return conceptDictionary.count
    }
    
    public func conceptSetAsDictionary() -> Dictionary<VDLConceptObject, Double> {
        return conceptDictionary
    }
    
    public func refactorProbabilities() {
        
        // This refactors the probabilities of objects in the set to ensure they all add up to 1.
        
        let totalProbability = totalProbabilityCount()
        
        var newConceptDictionary = Dictionary<VDLConceptObject, Double>()
        
        for (concept, probability) in conceptDictionary {
            newConceptDictionary[concept] = probability / totalProbability
        }
        
        conceptDictionary = newConceptDictionary
    }
    
    public func totalProbabilityCount() -> Double {
        
        // Check that the probability of all concepts in the set adds up to 1.
        
        var probabilityCount = 0.0
        
        for (concept, probability) in conceptDictionary {
            probabilityCount += probability
        }
        
        return probabilityCount
    }
    
    public var description: String {
        
        var descriptionString = ""
        
        for (concept, probability) in self.conceptDictionary {
            descriptionString = descriptionString + "\n\(concept.uid) - \(probability)"
        }
        
        return descriptionString
    }
    
    /*

    
*/
}
