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
        
        let conceptGraph = VDLConceptGraph.sharedInstance
        
        println("\(conceptGraph)")
        
        let probabilitySet = conceptGraph.probabilitySetForConceptWithUid("ZOO", requireImages: false)
        
        println("\nProbability set for ZOO without requiring images: \(probabilitySet)");
        
        let nextProbabilitySet = conceptGraph.probabilitySetForConceptWithUid("ZOO", requireImages: true)
        
        println("\nProbability set for ZOO requiring images: \(nextProbabilitySet)");
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

