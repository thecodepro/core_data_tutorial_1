//
//  ViewController.swift
//  core_data_tutorial_1
//
//  Created by Zephaniah Cohen on 1/26/17.
//  Copyright © 2017 CodePro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var peopleCounter = 1
    
    var peopleContainer : [Person] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        reloadCoreDataChanges()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadCoreDataChanges() {
        
        peopleContainer.removeAll()
        
        do {
            peopleContainer += try appDelegate.persistentContainer.viewContext.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
     
        appDelegate.persistentContainer.performBackgroundTask { (backgroundContext) in
            let personEntity = Person(context: backgroundContext)
            
            personEntity.firstName = "Person \(self.peopleCounter)"
            personEntity.age = Int32(self.peopleCounter)
            
            self.peopleCounter += 1
            
            do {
                try backgroundContext.save()
                
                self.reloadCoreDataChanges()
                
                
              
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleContainer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = peopleContainer[indexPath.row].firstName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}









