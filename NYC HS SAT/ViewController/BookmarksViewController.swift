//
//  BookmarksViewController.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/10/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import UIKit

class BookmarksViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersistenceService.manager.getSavedSchoolInfo().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkedCell", for: indexPath)
        let savedSchools = PersistenceService.manager.getSavedSchoolInfo()[indexPath.row]
        cell.textLabel?.text = savedSchools.school.school_name.removeBadFormatString()
        cell.detailTextLabel?.text = savedSchools.school.dbn
        return cell
    }
    
    // Pass data to destination saved data variables
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let destination = segue.destination as! HSSATDetailsViewController
        destination.selectedSchoolFromSavedData = PersistenceService.manager.getSavedSchoolInfo()[indexPath.row].school
        destination.satScores = PersistenceService.manager.getSavedSchoolInfo()[indexPath.row].schoolSATInfo
        destination.isDataFromSavedData = true
    }
    
    // Swipe to delete row and delete from local save data
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PersistenceService.manager.removeSavedSchool(fromIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
