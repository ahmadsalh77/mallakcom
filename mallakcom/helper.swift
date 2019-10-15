//
//  helper.swift
//  haandyy
//
//  Created by Ahmad Saleh on 4/15/19.
//  Copyright © 2019 cbbtec. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class helper : NSObject  {
    
    class func GetUid () -> String {
        
        let uid = Auth.auth().currentUser?.uid
        return uid!
    }
    
    
    
}






