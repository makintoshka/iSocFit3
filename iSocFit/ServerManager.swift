//
//  ServerManager.swift
//  iSocFit
//
//  Created by makintosh on 31.03.2021.
//

import UIKit
import Alamofire
import AlamofireImage

class ServerManager: NSObject {
    
    static let sharedManager = ServerManager()
    
    private override init() {}
    
    private static var url: String = String("https://06f104b41ca2.ngrok.io")
    private static var token: String = ""

    
    func getUser(userID: String, onSuccess: @escaping (NSDictionary) -> (), onFailure: (_ error: Error, _ statusCode: NSInteger) -> Void){
        
        let currentUrl = ServerManager.url + "/api/user"
        
        struct Params: Encodable{
            
            
        }
        
        let params = Params()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)"
        ]
        
        
        AF.request(currentUrl,
                   headers: headers).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success(let JSON):
                let jsonDict = JSON as! NSDictionary
                onSuccess(jsonDict)
                var user = UserModel.currentUser
                UserModel.userName = (jsonDict.object(forKey: "username") as? String)!;
                UserModel.userID = (jsonDict.object(forKey: "userId") as? String)!;
                UserModel.firstName = (jsonDict.object(forKey: "firstName") as? String)!;
                UserModel.lastName = (jsonDict.object(forKey: "lastName") as? String)!;
                UserModel.email = (jsonDict.object(forKey: "email") as? String)!;
                UserModel.phoneNumber = (jsonDict.object(forKey: "phone") as? String)!;
                
                
            case .failure(let error):
                print(error)
                print(responseJSON)
            }
            
        }
        
    }
    
    func getUserAbout(completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        let currentUrl = ServerManager.url + "/api/user/about"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)"
        ]
        
        AF.request(currentUrl,
                   headers: headers).responseJSON { (responseJSON) in
                    switch responseJSON.result{
                    case .success(let json):
                        completionHandler(json as! NSDictionary, nil)
                    case .failure(let error):
                        completionHandler(nil, error as NSError)
                    }
                   }
    }
    
    func updateUserAbout(parameters: NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        let currentUrl = ServerManager.url + "/api/user/about"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)"
        ]
        
        let params = parameters.object(forKey: "about") as! String
        
        AF.request(currentUrl,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: headers,
                   interceptor: nil,
                   requestModifier: nil).responseJSON { (json) in
                    switch json.result {
                    case .success(let json):
                        completionHandler(json as! NSDictionary, nil)
                    case .failure(let error):
                        completionHandler(nil, error as NSError)
                    }
                   }
    }
    
    func authorizeUser(parameters: NSDictionary, completionHandler: @escaping (NSDictionary?, NSError?) -> () ){
        
        let currentUrl = ServerManager.url + "/token"
        
        struct Params: Encodable{
            
            var email = ""
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let params = Params(email: parameters.value(forKey: "email") as! String)
        
        AF.request(currentUrl,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: headers,
                   interceptor: nil,
                   requestModifier: nil).responseJSON { (response) in
                    switch response.result {
                    case .success(let JSON):
                        completionHandler(JSON as! NSDictionary, nil)
                        let jsonDict = JSON as! NSDictionary
                        let jsonObject = try! JSONSerialization.data(withJSONObject: JSON)
                        ServerManager.token = jsonDict.object(forKey: "access_token") as! String
                    case .failure(let error):
                        completionHandler(nil, error as NSError)
                    }
                   }
        
    }
    
    func updateUser(parameters: NSDictionary, competionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        let currentUrl = ServerManager.url + "/api/user"
        
        struct Params: Encodable{
            var phone: String
        }
        
        let params = Params(phone: parameters.object(forKey: "phone") as! String)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)",
            "Content-Type": "application/json"
        ]
        
        AF.request(currentUrl,
                   method: .put,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: headers,
                   interceptor: nil,
                   requestModifier: nil).responseJSON { (json) in
                    switch json.result {
                    case .success(let json):
                        competionHandler(json as! NSDictionary, nil)
                    case .failure(let error):
                        competionHandler(nil, error as NSError)
                    }
                   }
        
    }
    
    func getUserPhotoUrl(completionHandler: @escaping (String?, NSError?) -> ()){
     
        let currentUrl = ServerManager.url + "/api/user/avatar"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)"
        ]
        
        AF.request(currentUrl, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                let jsonDict = json as! NSDictionary
                let url = jsonDict.object(forKey: "value") as! String
                completionHandler(url, nil)
                
                
            case .failure(let error):
                completionHandler(nil, error as NSError)
            }
        }
        
    }
    
    func getUserPhoto(url: String, completionHandler: @escaping (UIImage?, NSError?) -> ()){
        
        let currentUrl = ServerManager.url + "/" + url

        let headers: HTTPHeaders = [
            "Content-Type":"image/jpeg"
        ]
        
        AF.request(currentUrl, headers: headers).responseImage { (responseImage) in
            switch responseImage.result{
            case .success(let image):
                let img = UIImage(data: responseImage.data!)
                completionHandler(img, nil)
            case .failure(let error):
                completionHandler(nil, error as NSError)
            }
        }
        
    }
    
    func getUserAbilities(completionHandler: @escaping (NSArray?, NSError?) -> () ){
        
        let currentUrl = ServerManager.url + "/api/user/stats"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)"
        ]
        
        AF.request(currentUrl,
                   headers: headers).responseJSON { (responseJSON) in
                    switch responseJSON.result {
                    case .success(let json):
                        completionHandler(json as! NSArray, nil)
                        //print(json)
                    case .failure(let error):
                        completionHandler(nil, error as NSError)

                    }
                    
                   }
        
    }
    
    func updateUserPhoto(photo: UIImage, photoFileName: String, completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        let currentUrl = ServerManager.url + "/api/user/avatar"
        
        let imageData = photo.jpegData(compressionQuality: 0.2)
        //let imageData = photo.pngData()
        
        let params = [
            "Content-Disposition": "form-data"
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)",
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multiPartFormData) in
            multiPartFormData.append(imageData!, withName: "image", fileName: photoFileName, mimeType: "image/jpeg")
            multiPartFormData.append("image/jpeg".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "Content-Type")
        }, to: currentUrl,
        usingThreshold: UInt64.init(),
        method: .post,
        headers: headers,
        interceptor: nil,
        fileManager: .default,
        requestModifier: nil).responseJSON { (JSON) in
            switch JSON.result{
            case .success(let json):
                completionHandler(json as! NSDictionary, nil)
            case .failure(let error):
                completionHandler(nil, error as NSError)
            }
            
        }
        
    }
    
    func getAbilityValues(abilityKey: String, completionHandler: @escaping (NSArray?, NSError?) -> ()){
        
        let currentUrl = ServerManager.url + "/api/user/stats/" + "\(abilityKey)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)"
        ]
        
        AF.request(currentUrl,
                   headers: headers).responseJSON { (responseJSON) in
                    switch responseJSON.result {
                    case .success(let json):
                        completionHandler(json as! NSArray, nil)
                    case .failure(let error):
                        completionHandler(nil, error as NSError)
                    }
                   }
        
    }
    
    func addAbility(parameters: NSDictionary, abilityKey: String, completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        let currentUrl = ServerManager.url + "/api/user/stats"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)",
            "Content-Type": "application/json"
        ]
        
        struct Params: Encodable {
            var key: String
            var value: Int
            var StatsCategoryId: String
        }
        
        let params = Params(key: parameters.object(forKey: "key") as! String,
                            value: parameters.object(forKey: "value") as! Int,
                            StatsCategoryId: parameters.object(forKey: "categoryId") as! String)
        
        
        
        AF.request(currentUrl,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: headers,
                   interceptor: nil,
                   requestModifier: nil).responseJSON { (json) in
                    switch json.result {
                    case .success(let json):
                        completionHandler(json as! NSDictionary, nil)
                    case .failure(let error):
                        completionHandler(nil, error as NSError)
                    }
                   }
        
    }
    
    func getWorkouts(completionHandler: @escaping (NSArray?, NSError?) -> ()){
        
        let currentUrl = ServerManager.url + "/api/workout"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)"
        ]
        
        AF.request(currentUrl,
                   headers: headers).responseJSON { (responseJSON) in
                    switch responseJSON.result{
                    case .success(let json):
                        completionHandler(json as! NSArray, nil)
                    case .failure(let error):
                        completionHandler(nil, error as! NSError)
                    }
                   }
        
    }
    
    func getWorkoutExercises(id: String, completionHandler: @escaping (NSArray?, NSError?) -> ()){
        
        
        let currentUrl = ServerManager.url + "/api/workout/" + id + "/exercises"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ServerManager.token)"
        ]
        
        AF.request(currentUrl,
                   headers: headers).responseJSON { (responseJSON) in
                    switch responseJSON.result{
                    case .success(let json):
                        completionHandler(json as! NSArray, nil)
                    case .failure(let error):
                        completionHandler(nil, error as! NSError)
                    }
                   }
        
    }
    
}
