//
//  VChomeProvider.swift
//  mallakcom
//
//  Created by mohave on 9/9/19.
//  Copyright © 2019 mallakcom. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class VChomeProvider: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
	
    }
    
 
    @IBAction func signOut(_ sender: Any) {
                do{
                    try? Auth.auth().signOut()
                }

    }
    
    
}
