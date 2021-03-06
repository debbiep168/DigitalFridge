//
//  FridgeItems.swift
//  DigitalFridge
//
//  Created by Debbie Pao on 11/29/17.
//  Copyright © 2017 Debbie Pao. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

var user: String = "";

//ADDS NEW ITEM TO FIREBASE
func addItem(itemName: String, expirDate: String, dateBought: String) {
    print("adding to firebase")
    if itemName == "" || expirDate == "" || dateBought == "" {
        let alertController = UIAlertController(title: "Form Error.", message: "Please fill in form completely.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        //present(alertController, animated: true, completion: nil)
    } else {
        let dbRef = FIRDatabase.database().reference()
        let postDict: [String:AnyObject] = ["itemName": itemName as AnyObject,
                                            "expiration": expirDate as AnyObject,
                                            "dateBought": dateBought as AnyObject]
        if let currentUser = FIRAuth.auth()?.currentUser?.email {
            var arr = currentUser.components(separatedBy: ".")
            user = arr[0]
            let newPostKey = dbRef.child("/" +  user + "/Items/").childByAutoId().key;
            let childUpdates = ["/\(user)/Items/\(newPostKey)": postDict]
            dbRef.updateChildValues(childUpdates);
        }
    }
}

//GET ITEMS FROM FIREBASE FOR EACH USER
func getItemsInFridge() {
    let dbRef = FIRDatabase.database().reference()
    if let currentUser = FIRAuth.auth()?.currentUser?.email {
        var arr = currentUser.components(separatedBy: ".")
        user = arr[0]
    }
    dbRef.child("/\(user)/Items").observeSingleEvent(of: .value, with: { snapshot -> Void in
        if snapshot.exists() {
            if let posts = snapshot.value as? [String:AnyObject] {
                print(posts)
                /*
                 RETURNS BACK THIS:
                 ["-L-9xCjiQvGPkFfHGHQF": {
                 dateBought = "11/1/17";
                 expiration = "12/1/17";
                 itemName = cookies;
                 }, "-L-9ynDUYTrOkcNBOd3-": {
                 dateBought = "1/1/17";
                 expiration = "1/1/18";
                 itemName = soda;
                 }, "-L-9x6-RE4DZHDI2czHq": {
                 dateBought = "12/1/17";
                 expiration = "1/1/18";
                 itemName = toast;
                 }]
                 */
            }
        }
    })
}


