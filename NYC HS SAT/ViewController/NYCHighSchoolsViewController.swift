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
    
    // MARK: - Properties
    private var selectedSearchSegment = 0
    private var nycHighSchools = [NYCHighSchool]()
    private var filteredResults = [NYCHighSchool]() {
        didSet {
            DispatchQueue.main.async {
                self.highSchoolsTableView?.reloadData()
            }
        }
    }
    // Trigger for getting data for the selected borough
    public var selectedBorough = ("", "") {
        didSet {
            navigationItem.title = selectedBorough.1
            getAllHighSchools(from: selectedBorough.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highSchoolsTableView.dataSource = self
        searchBar.delegate = self
    }
    
    // Function for network call
    // Because the API doesn't return that many results per borough, it's safe to get all the data back all at once. However, it would be neccessary to limit results if the data set is large, and tail loading more results.
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
            self.showAlert(title: "Error", message: "Unable to load data, please check your network connection.")
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
    
    // Passes the information of selected high school when segueing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = highSchoolsTableView.indexPathForSelectedRow else {return}
        if let destination = segue.destination as? HSSATDetailsViewController {
            destination.selectedSchool = filteredResults[indexPath.row]
        }
    }
}

// Mark: - TableView DataSource Methods
extension NYCHighSchoolsViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HSCell", for: indexPath)
        let highSchool = filteredResults[indexPath.row]
        
        // result has some weird characters
        if selectedSearchSegment == 0 {
            cell.textLabel?.text = highSchool.school_name.removeBadFormatString() //this hopefully fixes some
            cell.detailTextLabel?.text = highSchool.dbn
        }
        else { // shows dbn first when searching by dbn
            cell.textLabel?.text = highSchool.dbn
            cell.detailTextLabel?.text = highSchool.school_name.removeBadFormatString()
        }
        return cell
    }
}

// MARK: - SearchBar Delegate Methods
extension NYCHighSchoolsViewController: UISearchBarDelegate {
    internal func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        selectedSearchSegment = selectedScope
        
        // Change sort order when segment changes and search bar placeholder
        if selectedScope == 0 { // sort school name alphabetically
            searchBar.placeholder = "Search school name"
            filteredResults.sort{$0.school_name < $1.school_name}
        } else { // sort by ascending dbn
            searchBar.placeholder = "Search DBN"
            filteredResults.sort{$0.dbn < $1.dbn}
        }
        highSchoolsTableView.reloadData()
    }
    
    // Hide keyboard and clears search text
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            filteredResults = nycHighSchools // Resets to display all schools in boro
        } else { // Live filtering for result
            if selectedSearchSegment == 0 { // filter by school name
                filteredResults = nycHighSchools.filter{$0.school_name.localizedCaseInsensitiveContains(searchBar.text!)}
            } else { // filter by district borough number
                filteredResults = nycHighSchools.filter{$0.dbn.localizedCaseInsensitiveContains(searchBar.text!)}
            }
        }
    }
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension String { // Func for removing some strings from response data
    public func removeBadFormatString() -> String {
        // Hardcoded approach since I only found these to appear in the data
        var str = self
        str = str.replacingOccurrences(of: "Â“47Â”", with: "")
            .replacingOccurrences(of: "Â", with: "")
        return str
    }
}
