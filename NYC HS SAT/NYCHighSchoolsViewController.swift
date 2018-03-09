//
//  ViewController.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/9/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import UIKit

class NYCHighSchoolsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var highSchoolsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set tableView delegate and dataSource
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//Mark: - TableView DataSource Methods
extension NYCHighSchoolsViewController: UITableViewDataSource {
    
    
}
