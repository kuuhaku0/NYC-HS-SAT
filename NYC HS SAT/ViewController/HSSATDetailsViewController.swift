//
//  HSSATDetailsViewController.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/9/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import UIKit

class HSSATDetailsViewController: UIViewController {

    public var selectedSchool: NYCHighSchool! {
        didSet {
            loadData(for: selectedSchool!.dbn)
        }
    }
    private var satScores = [SATScores]() {
        didSet {
            print(satScores)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func loadData(for school: String) {
        let completion: ([SATScores]) -> Void = {(onlineSATScore) in
            self.satScores = onlineSATScore
        }
        let error: (Error) -> Void = {(error) in
            //TODO
        }
        SATScoresAPIClient.manager.getSATScore(forSchool: school,
                                               completionHandler: completion,
                                               errorHandler: error)
    }
}
