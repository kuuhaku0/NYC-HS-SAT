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
        let token = "9ubKuJcvrZbHBNOSLWvi1a7Ux"
        let urlStr = "https://data.cityofnewyork.us/resource/97mf-9njv.json?boro=\(borough)&$$app_token=\(token)"
        
        // Try to fetch data from cache using the URL as key
        if let cache = CacheService.manager.getHighSchools(fromURL: urlStr) {
            print("getting from cache")
            completionHandler(cache)
        } else { // Doesn't exist in cache, makes network request
            print("making network request")
            let request = URLRequest(url: URL(string: urlStr)!)
            
            // completion
            let parseNYCHS: (Data) -> Void = {(data: Data) in
                do {
                    let allHSInBoro = try JSONDecoder().decode([NYCHighSchool].self, from: data)
                    CacheService.manager.addToCache(highSchools: allHSInBoro, withUrlStr: urlStr)
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
}
