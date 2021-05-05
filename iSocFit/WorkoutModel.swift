//
//  WorkoutModel.swift
//  iSocFit
//
//  Created by makintosh on 04.05.2021.
//

import UIKit

class WorkoutModel: NSObject {
    
    var id: String = ""
    var about: String = ""
    var createdAt: String = ""
    var name: String = ""
    var exercises: [String:Exercise] = [:]
    
    init(id: String, about: String, created: String, name: String) {
        self.id = id
        self.about = about
        self.createdAt = created
        self.name = name
    }
    
}
