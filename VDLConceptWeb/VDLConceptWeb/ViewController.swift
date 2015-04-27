//
//  ViewController.swift
//  VDLConceptWeb
//
//  Created by Andrew J Clark on 27/04/2015.
//  Copyright (c) 2015 Andrew J Clark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let conceptWeb = VDLConceptGraph.sharedInstance
        
        println(conceptWeb)
        
        let startingConcept = conceptWeb.conceptWithUid("ZOO")
        
        let probabilitySet = conceptWeb.probabilitySetForConcept(startingConcept, requireImages: false)
        
        println("\nProbability set for ZOO without requiring images");
        
        for (concept, probability) in probabilitySet.conceptDictionary {
            println("\(concept.uid) - \(probability)")
        }
        
        let nextProbabilitySet = conceptWeb.probabilitySetForConcept(startingConcept, requireImages: true)
        
        println("\nProbability set for ZOO requiring images");
        
        for (concept, probability) in nextProbabilitySet.conceptDictionary {
            println("\(concept.uid) - \(probability)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

