//
//  WebConcept.swift
//  ObjectWebTest1
//
//  Created by Andrew J Clark on 12/04/2015.
//  Copyright (c) 2015 Andrew J Clark. All rights reserved.
//

import Foundation

public class VDLConceptObject: Hashable, Printable {
    
    public var uid = ""
    
    // The concepts that this object is related to and can introspect on
    public var relatedConcepts = Set<VDLConceptObject>()
    
    // A passive set of the concepts that count this object as a relatedConcept
    public var relativeOfConcepts = Set<VDLConceptObject>()
    
    public var images = Set<String>()
    
    public var hashValue: Int {
        return self.uid.hashValue
    }
    
    public var description: String {
        // Returns a string that lists the UID of self, the UIDs of the related concepts, and the images.
        
        var relativeUIDs = Set<String>()
        var relativeOfUIDs = Set<String>()
        
        for related in relatedConcepts {
            relativeUIDs.insert(related.uid)
        }
        
        for relatedOf in relativeOfConcepts {
            relativeOfUIDs.insert(relatedOf.uid)
        }
        
        var relativeString = ",".join(relativeUIDs)
        var imageString = ",".join(images)
        
        return "\(uid) \(relativeString) \(imageString)"
    }
    
    public func introspectRelatedConcepts(exclude: Set<VDLConceptObject>, requireImages: Bool) -> VDLConceptProbabilitySet {
        
        var conceptSet = VDLConceptProbabilitySet()
        
        var excludeSet = exclude
        
        var childCount = 0
        
        // Insert self into the exclude set if allowed.
        if exclude.contains(self) == false {
            childCount += 1
        }
        
        // Count the allowed relatedConcepts but make sure these are not already excluded
        
        var allowedRelatedConcepts:[VDLConceptObject] = []
        
        for concept in relatedConcepts {
            if excludeSet.contains(concept) == false {
                allowedRelatedConcepts.append(concept)
                excludeSet.insert(concept)
            }
        }
        
        childCount += allowedRelatedConcepts.count
        
        // allowedRelatedConcepts now contains all of the concepts that we are allowed to traverse
        
        let childProbability = 1.0
        
        if childCount > 0 {
            
            for related in allowedRelatedConcepts {
                
                // Introspect the related concepts and add their concepts in the conceptSet (and add them to the exclude set).
                let relatedIntrospectConceptSet = related.introspectRelatedConcepts(excludeSet, requireImages: requireImages)
                
                for (child, relatedProbability) in relatedIntrospectConceptSet.conceptDictionary {
                    
                    conceptSet.insertConcept(child, probability: 1 * relatedProbability)
                    
                    excludeSet.insert(child)
                }
            }
        }
        
        // Add self to the concept set IF it has images with a probability of 1. This means that self has the same probability weighting of all of its children combined. These weightings will all get refactored below so that they all add up to 1.
        if requireImages == false || images.count > 0 {
            conceptSet.insertConcept(self, probability: 1)
        }
        
        // Now we need to equalize the probabilities of all of the children so that they add up to 1.
        conceptSet.refactorProbabilities()
        
        return conceptSet
    }
}


public func ==(lhs: VDLConceptObject, rhs: VDLConceptObject) -> Bool {
    return lhs.hashValue == rhs.hashValue
}