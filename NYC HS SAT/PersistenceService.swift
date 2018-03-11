//
//  PersistenceService.swift
//  NYC HS SAT
//
//  Created by C4Q on 3/10/18.
//  Copyright © 2018 basedOnTy. All rights reserved.
//

import Foundation

class PersistenceService {
    private init() {}
    static let searchHistoryPath = "SavedSchools.plist"
    static let manager = PersistenceService()
    
    private var savedSchools = [SavedSchool]() {
        didSet {
            saveToDisk()
        }
    }
    
    public func getSavedSchoolInfo() -> [SavedSchool] {
        return self.savedSchools
    }
    
    public func addToFavorites(school: NYCHighSchool, satInfo: [SATScores]) -> Bool  {
        // checking for uniqueness
        let indexExist = self.savedSchools.index{ $0.school.dbn == school.dbn }
        if indexExist != nil { print("DATA ALREADY EXIST"); return false }
        
        // 2) save favorite object
        let newFavorite = SavedSchool.init(school: school, schoolSATInfo: satInfo)
        self.savedSchools.append(newFavorite)
        return true
    }
    
    // save to documents directory
    // write to path: /Documents/
    private func saveToDisk() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(savedSchools)
            // Does the writing to disk
            try data.write(to: dataFilePath(withPathName: PersistenceService.searchHistoryPath), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
        print("\n==================================================")
        print(documentsDirectory())
        print("==================================================\n")
    }
    
    // returns documents directory path for app sandbox
    public func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    public func loadData() {
        let propertyDecoder = PropertyListDecoder()
        let path = dataFilePath(withPathName: PersistenceService.searchHistoryPath)
        do {
            let data = try Data(contentsOf: path)
            let savedSchoolsRequested = try propertyDecoder.decode([SavedSchool].self, from: data)
            self.savedSchools = savedSchoolsRequested
        }
        catch {
            print(error)
        }
    }
    
    private func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath(withPathName path: String) -> URL {
        return PersistenceService.manager.documentDirectory().appendingPathComponent(path)
    }
    
    // Simply removes from saved array
    public func removeSavedSchool(fromIndex index: Int) {
        savedSchools.remove(at: index)
    }
}
