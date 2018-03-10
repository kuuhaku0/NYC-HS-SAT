//
//  HSSATDetailsViewController.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/9/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import UIKit

class HSSATDetailsViewController: UIViewController {
    // IBOutlets
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var readingScoreLabel: UILabel!
    @IBOutlet weak var mathScoreLabel: UILabel!
    @IBOutlet weak var writingScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var noResultsView: UIView!
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var totalTestTakersLabel: UILabel!
    
    public var selectedSchool: NYCHighSchool! {
        didSet {
            loadData(for: selectedSchool!.dbn)
        }
    }
    private var satScores: [SATScores]? {
        didSet {
            setupUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUI() {
        // Display school name passed over
        schoolNameLabel.text = selectedSchool.school_name.removeBadFormatString()
        
        // Displays SAT information based on if the result array is empty
        if let result = satScores?.first { //not empty
            readingScoreLabel.text = result.sat_critical_reading_avg_score
            mathScoreLabel.text = result.sat_math_avg_score
            writingScoreLabel.text = result.sat_writing_avg_score
            
            let total // total score out of 2100
                = Int(result.sat_writing_avg_score)!
                + Int(result.sat_math_avg_score)!
                + Int(result.sat_critical_reading_avg_score)!
            
            totalScoreLabel.text = String(total) + " / 2100"
            totalTestTakersLabel.text = "Number of test takers: \(result.num_of_sat_test_takers)"
            
        } else { // empty
            noResultsView.isHidden = false
        }
    }
    
    // Network call with SATScoresAPIClient
    private func loadData(for school: String) {
        let completion: ([SATScores]) -> Void = {(onlineSATScore) in
            self.satScores = onlineSATScore
        }
        let error: (Error) -> Void = {(error) in
            self.showAlert(title: "Error", message: "Unable to load data, please check your network connection.")
        }
        SATScoresAPIClient.manager.getSATScore(forSchool: school,
                                               completionHandler: completion,
                                               errorHandler: error)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
