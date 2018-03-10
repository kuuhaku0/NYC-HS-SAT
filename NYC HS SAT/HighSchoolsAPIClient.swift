//
//  HighSchoolsAPIClient.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/9/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import Foundation

struct HighSchoolsAPIClient {
    private init() {}
    static let manager = HighSchoolsAPIClient()
    func getAllSchools(from borough: String,
                       completionHandler: @escaping ([NYCHighSchool]) -> Void,
                       errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://data.cityofnewyork.us/resource/97mf-9njv.json?boro=\(borough)"
        print(urlStr)
        let request = URLRequest(url: URL(string: urlStr)!)
        
        // Closure for NetworkHelper
        let parseNYCHS: (Data) -> Void = {(data: Data) in
            do {
                let allHSInBoro = try JSONDecoder().decode([NYCHighSchool].self, from: data)
                completionHandler(allHSInBoro)
            } catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: parseNYCHS,
                                              errorHandler: errorHandler)
    }
}
