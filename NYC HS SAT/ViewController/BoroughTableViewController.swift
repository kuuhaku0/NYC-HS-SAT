//
//  BoroughTableViewController.swift
//  
//
//  Created by C4Q on 3/9/18.
//

import UIKit

class BoroughTableViewController: UITableViewController {
    
    // Data Source for tableView
    private let boroughs = [("Manhattan", #imageLiteral(resourceName: "Manhattan")), ("Brooklyn", #imageLiteral(resourceName: "Brooklyn")), ("Queens", #imageLiteral(resourceName: "Queens")), ("Bronx", #imageLiteral(resourceName: "Bronx")), ("Staten Island", #imageLiteral(resourceName: "Staten Island"))]
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BoroughTableViewCell
        let destination = NYCHighSchoolsViewController()
        
        // Converts borough name into boro code for API request
        var selectedBoroCode: String {
            var code = ""
            switch cell.BoroughLabel.text!{
            case "Manhattan":
                code = "M"
            case "Queens":
                code = "Q"
            case "Brooklyn":
                code = "K"
            case "Bronx":
                code = "X"
            case "Staten Island":
                code = "R"
            default:
                break
            }
            return code
        }
        destination.selectedBorough = selectedBoroCode
    }
}
