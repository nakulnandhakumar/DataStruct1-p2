//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Nakul Nandhakumar on 4/22/20.
//  Copyright © 2020 Nakul Nandhakumar. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: UIViewController {

    @IBOutlet weak var createUsername: UITextField!
    @IBOutlet weak var createPassword: UITextField!
    
    @IBOutlet weak var usernameEnter: UITextField!
    @IBOutlet weak var passwordEnter: UITextField!
    
    var username = String()
    var password = String()
    
    var userText = String()
    var passText = String()
    
    var EnteredUsername = String()
    var EnteredPassword = String()
    
    var usernameInfo = [String]()
    var passwordInfo = [String]()
    
    var count = Int()
    var i = Int()
    var exitFlag = Int()
    
    override func viewDidLoad() {
        getData()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccount(_ sender: Any) {
        count += 1
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let userInfo = NSManagedObject(entity: userEntity!, insertInto:  context)
        
        guard let userText = createUsername.text, !userText.isEmpty else {return}
        guard let passText = createPassword.text, !passText.isEmpty else {return}
        
        userInfo.setValue(userText, forKey: "username")
        userInfo.setValue(passText, forKey: "password")
        userInfo.setValue(count, forKey: "count")
        
        do {
            try context.save()
            print("Save successful")
            getData()
            usernameInfo.append(username)
            passwordInfo.append(password)
        } catch {
            print("Save failed")
        }
        
    }
    
    func getData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                username = data.value(forKey: "username") as! String
                usernameInfo.append(username)
                password = data.value(forKey: "password") as! String
                passwordInfo.append(password)
                count = data.value(forKey: "count") as! Int
            }
          } catch {
            print("Fetch failed")
        }
    }
    
    @IBAction func deleteAllAccounts(_ sender: Any)
    {
        count = 0
        usernameInfo.removeAll()
        passwordInfo.removeAll()
    }
    
    @IBAction func loginCheck(_ sender: Any)
    {
        i = 0
        EnteredUsername = usernameEnter.text!
        EnteredPassword = passwordEnter.text!
        while i < usernameInfo.count {
            if EnteredUsername == usernameInfo[i]
            {
                if EnteredPassword == passwordInfo[i]
                {
                    print("Access Granted")
                    exitFlag = 0
                }
                else {
                    print("Access Denied")
                    exitFlag = 1
                }
            }
            
            if exitFlag == 0
            {
                exitFlag = 99
                i = usernameInfo.count
                break
            }
            
            if exitFlag == 1
            {
                exitFlag = 99
                i = usernameInfo.count
                break
            }
                
            else
            {
                i += 1
                if i == usernameInfo.count
                {
                    print("Access Denied")
                    break
                }
            }
            
        }
    }
}

