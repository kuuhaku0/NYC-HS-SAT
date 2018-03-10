//
//  BoroughTableViewController.swift
//  
//
//  Created by C4Q on 3/9/18.
//

import UIKit

class BoroughTableViewController: UITableViewController {
    
    // Data Source for tableView
    private let boroughs = [("Manhattan", #imageLiteral(resourceName: "Manhattan"), "M"), ("Brooklyn", #imageLiteral(resourceName: "Brooklyn"), "K"), ("Queens", #imageLiteral(resourceName: "Queens"), "Q"), ("Bronx", #imageLiteral(resourceName: "Bronx"), "X"), ("Staten Island", #imageLiteral(resourceName: "Staten Island"), "R")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tabeView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boroughs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoroughCell", for: indexPath) as! BoroughTableViewCell
        let borough = boroughs[indexPath.row]
        cell.BoroughLabel.text = borough.0
        cell.boroughImage.image = borough.1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Sizing the cells to fit inside safeAreaLayout
        return view.safeAreaLayoutGuide.layoutFrame.height / CGFloat(boroughs.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        let destination = segue.destination as! NYCHighSchoolsViewController
        var selectedBoroCode: (String, String) {
            var code = ("", "")
            switch indexPath.row {
            case 0:
                code = ("M", "Manhattan")
            case 1:
                code = ("K", "Brooklyn")
            case 2:
                code = ("Q", "Queens")
            case 3:
                code = ("X", "Bronx")
            case 4:
                code = ("R", "Staten Island")
            default:
                break
            }
            return code
        }
        destination.selectedBorough = selectedBoroCode
    }
}
