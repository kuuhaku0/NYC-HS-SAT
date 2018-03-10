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
    @IBAction func reload(_ sender: UIButton) {
        highSchoolsTableView?.reloadData()
    }
    
    // Trigger for getting data for the selected borough
    public var selectedBorough = ("", "") {
        didSet {
            navigationItem.title = selectedBorough.1
            getAllHighSchools(from: selectedBorough.0)
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
        highSchoolsTableView.dataSource = self
        highSchoolsTableView.delegate = self
        
        searchBar.delegate = self
        highSchoolsTableView?.reloadData()
    }

    private func getAllHighSchools(from borough: String) {
        let completion: ([NYCHighSchool]) -> Void = {(onlineHSInBoro) in
            self.nycHighSchools = onlineHSInBoro
            self.highSchoolsTableView?.reloadData()
        }
        HighSchoolsAPIClient.manager.getAllSchools(from: borough,
                                                   completionHandler: completion,
                                                   errorHandler: {print($0)})
    }
}

// Mark: - TableView DataSource Methods
extension NYCHighSchoolsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nycHighSchools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HSCell", for: indexPath)
        let highSchool = nycHighSchools[indexPath.row]

        cell.textLabel?.text = highSchool.school_name
        cell.detailTextLabel?.text = highSchool.dbn
        return cell
    }
}

// Mark: - TableView Delegate Methods
extension NYCHighSchoolsViewController: UITableViewDelegate {

}
// MARK: - SearchBar Delegate Methods
extension NYCHighSchoolsViewController: UISearchBarDelegate {
    
}
