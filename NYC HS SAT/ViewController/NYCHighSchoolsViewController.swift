//
//  ViewController.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/9/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import UIKit

class NYCHighSchoolsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var highSchoolsTableView: UITableView!
    
    // Trigger for getting data for the selected borough
    public var selectedBorough = "" {
        didSet {
            getAllHighSchools(from: selectedBorough)
        }
    }
    
    private var nycHighSchools = [NYCHighSchool]() {
        didSet {
            print(nycHighSchools.count)
            highSchoolsTableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegate and dataSource
        searchBar.delegate = self
        
        highSchoolsTableView.delegate = self
        highSchoolsTableView.dataSource = self
    }

    private func getAllHighSchools(from borough: String) {
        let completion: ([NYCHighSchool]) -> Void = {(onlineHSInBoro) in
            self.nycHighSchools = onlineHSInBoro
        }
        HighSchoolsAPIClient.manager.getAllSchools(from: borough,
                                                   completionHandler: completion,
                                                   errorHandler: {print($0)})
    }
}

// Mark: - TableView DataSource Methods
extension NYCHighSchoolsViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nycHighSchools.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = highSchoolsTableView.dequeueReusableCell(withIdentifier: "HSCell", for: indexPath)
        let highSchool = nycHighSchools[indexPath.row]
        cell.textLabel?.text = highSchool.school_name
        return cell
    }
}

// Mark: - TableView Delegate Methods
extension NYCHighSchoolsViewController: UITableViewDelegate {

}
// MARK: - SearchBar Delegate Methods
extension NYCHighSchoolsViewController: UISearchBarDelegate {
    
}
