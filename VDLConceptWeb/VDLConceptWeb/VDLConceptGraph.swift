//
//  VDLConceptGraph.swift
//  Voidology Concept Web
//
//  Created by Andrew J Clark on 20/04/2015.
//  Copyright (c) 2015 Andrew J Clark. All rights reserved.
//

import Foundation

public class VDLConceptGraph: Printable {
    
    var concepts = Dictionary<String, VDLConceptObject>()
    
    class var sharedInstance: VDLConceptGraph {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: VDLConceptGraph? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = VDLConceptGraph()
        }
        
        return Static.instance!
    }
    
    public var description: String {
        
        var conceptsString = "VDLConceptGraph contains \(concepts.count) concepts..."
        
        for (uid, concept) in concepts {
            conceptsString += "\n- \(concept) (key: \(uid))"
        }
        
        return conceptsString
    }
    
    
    init() {
        
        println("VDLConceptGraph loading ConceptIndex.conceptindex from bundle")
        
        if let filePath = NSBundle.mainBundle().pathForResource("ConceptIndex", ofType:"conceptindex") {
            
            let loadedString = String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil)
            
            let conceptStringArray = loadedString!.componentsSeparatedByString("\n")
            
            for conceptString in conceptStringArray {
                
                // If this object is empty or starts with "//" then skip it
                
                var skipLine = false
                
                if count(conceptString) <= 2 {
                    skipLine = true
                } else if count(conceptString) > 2 {
                    let endIndex = advance(conceptString.startIndex, 2)
                    let firstTwoChars = conceptString.substringToIndex(endIndex)
                    
                    if firstTwoChars == "//" {
                        skipLine = true
                    }
                }
                
                if skipLine == false {
                    let stringArray = conceptString.componentsSeparatedByString(" ")
                    
                    // Get the concept with this UID from self (may or may not be a new concept)
                    if count(stringArray) >= 1 {
                        let idString = stringArray[0]
                        
                        var newItem = self.conceptWithUid(idString)
                        
                        // Get the relativeTo objects
                        if count(stringArray) >= 2 {
                            let relativeToString = stringArray[1]
                            
                            if count(relativeToString) > 0 {
                                let conceptUids = relativeToString.componentsSeparatedByString(",")
                                
                                for conceptUid in conceptUids {
                                    
                                    var concept = self.conceptWithUid(conceptUid)
                                    
                                    if concept != newItem {
                                        newItem.relatedConcepts.insert(concept)
                                        // Set the relativeOf in the inverse direction.
                                        concept.relativeOfConcepts.insert(newItem)
                                    }
                                }
                            }
                        }
                        
                        // Get the images
                        if count(stringArray) >= 3 {
                            let imagesString = stringArray[2]
                            
                            for image in imagesString.componentsSeparatedByString(",") {
                                
                                newItem.images.insert(image)
                            }
                        }
                    }
                }
            }
        }
        
        println("VDLConceptGraph loaded \(concepts.count) concepts")
    }
    
    
    public func probabilitySetForConcept(concept: VDLConceptObject, requireImages: Bool) -> VDLConceptProbabilitySet {
        // Introspect the provided concept and return a VDLConceptProbabilitySet
        return concept.introspectRelatedConcepts(Set<VDLConceptObject>(), requireImages: requireImages)
    }
    
    public func conceptWithUid(uid: String) -> VDLConceptObject {
        // Return the VDLConceptObject with the provided UID, creating it first if necessary.
        if let concept = concepts[uid] {
            return concept
        } else {
            var newConcept = VDLConceptObject()
            newConcept.uid = uid
            concepts[uid] = newConcept
            return newConcept
        }
    }
}