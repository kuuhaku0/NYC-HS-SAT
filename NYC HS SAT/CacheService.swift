//
//  CacheService.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/11/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import Foundation

class CacheService {
    private init(){}
    static let manager = CacheService()
    
    private var nycHighSchools: [String: [NYCHighSchool]] = [:]
    
    public func addToCache(highSchools: [NYCHighSchool], withUrlStr urlStr: String) {
        self.nycHighSchools[urlStr] = highSchools
    }
   
    public func getHighSchools(fromURL urlStr: String) -> [NYCHighSchool]? {
        if let nycHS = self.nycHighSchools[urlStr] {
            if nycHS.isEmpty {
                return nil
            }
            return nycHS
        }
        return nil
    }
}
