//
//  ViewController.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/9/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import UIKit
import SVProgressHUD

class NYCHighSchoolsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var highSchoolsTableView: UITableView!
    
    // Trigger for getting data for the selected borough
    public var selectedBorough = ("", "") {
        didSet {
            navigationItem.title = selectedBorough.1
            getAllHighSchools(from: selectedBorough.0)
        }
    }
    
    private var nycHighSchools = [NYCHighSchool]()
    private var filteredResults = [NYCHighSchool]() {
        didSet {
            DispatchQueue.main.async {
                self.highSchoolsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegate and dataSource
        highSchoolsTableView.dataSource = self
        highSchoolsTableView.delegate = self
        
        searchBar.delegate = self
    }
    
    // Function for network call
    private func getAllHighSchools(from borough: String) {
        SVProgressHUD.show() //loading indicator
        
        // Sort alphabetically and dismiss loading indicator
        let completion: ([NYCHighSchool]) -> Void = {(onlineHSInBoro) in
            self.nycHighSchools = onlineHSInBoro.sorted {$0.school_name < $1.school_name}
            self.filteredResults = onlineHSInBoro.sorted {$0.school_name < $1.school_name}
            SVProgressHUD.dismiss()
        }
        // Show alert and dismiss loading indicator
        let error: (Error) -> Void = {(error) in
            self.showAlert(title: "Error", message: error.localizedDescription)
            SVProgressHUD.dismiss()
        }
        HighSchoolsAPIClient.manager.getAllSchools(from: borough,
                                                   completionHandler: completion,
                                                   errorHandler: error)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = highSchoolsTableView.indexPathForSelectedRow else {return}
        
        let destination = segue.destination as! HSSATDetailsViewController
        destination.selectedSchool = nycHighSchools[indexPath.row]
    }
}

// Mark: - TableView DataSource Methods
extension NYCHighSchoolsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HSCell", for: indexPath)
        let highSchool = filteredResults[indexPath.row]

        // result has some weird characters
        cell.textLabel?.text = highSchool.school_name
            .replacingOccurrences(of: "Â“47Â”", with: "")
            .replacingOccurrences(of: "Â", with: "") //this hopefully fixes some
        cell.detailTextLabel?.text = highSchool.dbn
        return cell
    }
}

// Mark: - TableView Delegate Methods
extension NYCHighSchoolsViewController: UITableViewDelegate {

}

// MARK: - SearchBar Delegate Methods
extension NYCHighSchoolsViewController: UISearchBarDelegate {
    // Hide keyboard and clears search text
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            filteredResults = nycHighSchools // Resets to display all schools in boro
            DispatchQueue.main.async {
                self.highSchoolsTableView.reloadData()
            }
        } else { // Live filtering for result
            filteredResults = nycHighSchools.filter {$0.school_name.localizedCaseInsensitiveContains(searchBar.text!)}
        }
    }
}
