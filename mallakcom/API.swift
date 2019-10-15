import UIKit
import Firebase
import FirebaseMessaging
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import CodableFirebase

class API: NSObject {
    
    var db: Firestore!
    static let sharedInstance = API()
    let uid = helper.GetUid()
    let def = UserDefaults.standard

    
    func getProfileInfo(onSuccess:@escaping (profileInfo?) -> Void, onFailed:@escaping (Error?) -> Void){
        //        let settings = FirestoreSettings()
        //        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        if  let userType : String = def.object(forKey: "userType") as? String  {
            switch userType {
            case "2":
                db.collection(Strings.providers).document(uid).getDocument { (DocumentSnapshot, Error) in
                    guard let value = DocumentSnapshot?.data() else { return }
                    do {
                        let model = try FirebaseDecoder().decode(profileInfo.self, from: value)
                        onSuccess(model)
                    } catch let error {
                        onFailed(error)
                    }
                }

            case "3":
                db.collection(Strings.users).document(uid).getDocument { (DocumentSnapshot, Error) in
                    guard let value = DocumentSnapshot?.data() else { return }
                    do {
                        let model = try FirebaseDecoder().decode(profileInfo.self, from: value)
                        onSuccess(model)
                    } catch let error {
                        onFailed(error)
                    }
                }

            default:
                print("not user or provider")
            }
    }
    }
    
    
    func setProfileInfo(parameter :[String : String] ,onSuccess:@escaping (Bool?) -> Void, onFailed:@escaping (Error?) -> Void){
        
        db = Firestore.firestore()
 
        if  let userType : String = def.object(forKey: "userType") as? String  {
            switch userType {
            case "2":
                db.collection(Strings.providers).document(uid).updateData(parameter) { (Error) in
                    
                    if Error != nil {
                        onFailed(Error)
                    }
                    else
                    {
                        onSuccess(true)
                    }
                    
                }
                
            case "3":
                db.collection(Strings.users).document(uid).setData(parameter) { (Error) in
                    if Error != nil {
                        onFailed(Error)
                        
                    }
                    else
                    {
                        onSuccess(true)
                        
                    }
                    
                }
                
            default:
                print("not user or provider !!")
            }
        }
        
        
    }
    
    func updateAddress(parameter :[String : String] ,onSuccess:@escaping (Bool?) -> Void, onFailed:@escaping (Error?) -> Void){
        
        db = Firestore.firestore()
        let def = UserDefaults.standard
        
        if  let userType : String = def.object(forKey: "userType") as? String  {
            switch userType {
            case "2":
                db.collection(Strings.providers).document(uid).collection("Address").document(uid + ".Address").setData(parameter) { (Error) in
 
                    if Error != nil {
                        onFailed(Error)
                    }
                    else
                    {
                        onSuccess(true)
                    }
                    
                }
                
            case "3":
                
                db.collection(Strings.providers).document(uid).collection("Address").document(uid + ".Address").setData(parameter) { (Error) in

                    if Error != nil {
                        onFailed(Error)
                        
                    }
                    else
                    {
                        onSuccess(true)
                        
                    }
                    
                }
                
            default:
                print("not user or provider !!")
            }
        }
        
        
    }
    
    func getAddress(onSuccess:@escaping (Address?) -> Void, onFailed:@escaping (Error?) -> Void){
        //        let settings = FirestoreSettings()
        //        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        if  let userType : String = def.object(forKey: "userType") as? String  {
            switch userType {
            case "2":
                 db.collection(Strings.providers).document(uid).collection("Address").document(uid +  ".Address").getDocument { (DocumentSnapshot, Error) in
  guard let value = DocumentSnapshot?.data() else { return }
                    do {
                        let model = try FirebaseDecoder().decode(Address.self, from: value)
                        onSuccess(model)
                    } catch let error {
                        onFailed(error)
                    }
                }
            case "3":
                db.collection(Strings.providers).document(uid).collection("Address").document(uid + ".Address").getDocument { (DocumentSnapshot, Error) in
                    guard let value = DocumentSnapshot?.data() else { return }
                    do {
                        let model = try FirebaseDecoder().decode(Address.self, from: value)
                        onSuccess(model)
                    } catch let error {
                        onFailed(error)
                    }
                }
                
            default:
                print("not user or provider")
            }
        }
    }
}


