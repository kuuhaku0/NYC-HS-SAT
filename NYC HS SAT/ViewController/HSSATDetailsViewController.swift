//
//  HSSATDetailsViewController.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/9/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import UIKit
import SVProgressHUD

class HSSATDetailsViewController: UIViewController {
    // IBOutlets
    @IBOutlet weak var dbnLabel: UILabel!
    @IBOutlet weak var totalStudentsLabel: UILabel!
    @IBOutlet weak var attendanceRate: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
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
    @IBAction func bookmarkButtonPressed(_ sender: UIButton) {
        saveSchoolInfo()
    }
    
    // Properties
    public var isDataFromSavedData = false
    public var selectedSchoolFromSavedData: NYCHighSchool?
    public var savedSATData: [SATScores]? // Being passed over from saved data, UI has not yet been loaded
    public var selectedSchool: NYCHighSchool? {
        didSet {
            if isDataFromSavedData == false {
                loadData(for: selectedSchool!.dbn)
            }
        }
    }
    public var satScores: [SATScores]? { // Being set async, setup UI after satScores is set
        didSet {
            setupUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if satScores != nil { // setup UI if coming from
            print("view did load")
            setupUI()
        }
    }
    
    // If I had more time, I would include a street view of the school and information about the school.
    private func setupUI() {
        // Display school name passed over
        if let schoolResult = selectedSchool ?? selectedSchoolFromSavedData {
            let attendancePercent = Double(schoolResult.attendance_rate) ?? 0
            if attendancePercent == 0 {
                attendanceRate?.text = "Attendance Rate: N/A"
            } else {
                attendanceRate?.text = "Attendance Rate: \(Int(attendancePercent * 100))%"
            }
            totalStudentsLabel?.text = "Total Students: \(schoolResult.total_students)"
            schoolNameLabel?.text = schoolResult.school_name.removeBadFormatString()
            addressLabel?.text = schoolResult.location.components(separatedBy: "(")[0]
            dbnLabel?.text = "DBN: \(schoolResult.dbn)"
        }
        
        // Hides bookmark button when loading from local saved data
        if isDataFromSavedData == true {
            bookmarkButton.isHidden = true
        }
        
        if let result = satScores?.first ?? savedSATData?.first {
            let readingScore = Int(result.sat_critical_reading_avg_score) ?? 0 // some of the results return "s"
            let mathScore = Int(result.sat_math_avg_score) ?? 0
            let writingScore = Int(result.sat_writing_avg_score) ?? 0
            readingScoreLabel?.text = "\(readingScore)"
            mathScoreLabel?.text = "\(mathScore)"
            writingScoreLabel?.text = "\(writingScore)"
            
            let total = readingScore + mathScore + writingScore
            totalScoreLabel?.text = String(total) + " / 2400"
            totalTestTakersLabel?.text = "Number of test takers: \(result.num_of_sat_test_takers)"
        } else { // empty
            noResultsView?.isHidden = false
        }
    }
    
    // Network call with SATScoresAPIClient
    private func loadData(for school: String) {
        SVProgressHUD.show()
        print("being called")
        let completion: ([SATScores]) -> Void = {(onlineSATScore) in
            self.satScores = onlineSATScore
            SVProgressHUD.dismiss()
        }
        let error: (Error) -> Void = {(error) in
            self.showAlert(title: "Error", message: "Unable to load data, please check your network connection.")
            self.bookmarkButton.isEnabled = false
            SVProgressHUD.dismiss()
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
    
    // Stores school info locally
    private func saveSchoolInfo() {
        // Displays different alert if saved data for school already exist
        if PersistenceService.manager.addToFavorites(school: self.selectedSchool!, satInfo: satScores ?? []) == true {
            showAlert(title: "Success", message: "Bookmarked current school")
        } else {
            showAlert(title: "Error", message: "Already bookmarked")
        }
    }
}
