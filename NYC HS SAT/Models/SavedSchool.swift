//
//  SavedSchool.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/10/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import Foundation

struct SavedSchool: Codable {
    let school: NYCHighSchool
    let schoolSATInfo: [SATScores]
}
