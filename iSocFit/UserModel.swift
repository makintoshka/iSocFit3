//
//  UserModel.swift
//  iSocFit
//
//  Created by makintosh on 31.03.2021.
//

import UIKit

class UserModel: NSObject{

    static let currentUser = UserModel()
    
    static var userID: String = ""
    static var firstName: String = ""
    static var lastName: String = ""
    static var email: String = ""
    static var imageURL: String = ""
    static var phoneNumber: String = ""
    static var userName: String = ""
    static var abilities: [String:NSMutableArray] = [:]
    static var workouts: [String:WorkoutModel] = [:]
    
    
    override init(){
        
    }
    
    /*static func getUser(from json: Any) -> [UserModel]? {
        
        guard let json = json as? [String: Any] else {
            return nil
        }
        
        
        
    }*/
    
}
