//
//  SATScoresAPIClient.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/9/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import Foundation

struct SATScoresAPIClient {
    private init () {}
    static let manager = SATScoresAPIClient()
    public func getSATScore(forSchool dbn: String,
                     completionHandler: @escaping ([SATScores]) -> Void,
                     errorHandler: @escaping (Error) -> Void) {
        let token = "9ubKuJcvrZbHBNOSLWvi1a7Ux"
        let urlStr = "https://data.cityofnewyork.us/resource/734v-jeq5.json?dbn=\(dbn)&$$app_token=\(token)"
        let request = URLRequest(url: URL(string: urlStr)!)

        // Completion for NetworkHelper
        let parseSATScore: (Data) -> Void = {(data) in
            do {
                let satScore = try JSONDecoder().decode([SATScores].self, from: data)
                completionHandler(satScore)
            } catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: parseSATScore,
                                              errorHandler: errorHandler)
    }
}
