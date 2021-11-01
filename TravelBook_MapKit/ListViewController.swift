//
//  ListViewController.swift
//  TravelBook_MapKit
//
//  Created by ysf on 01.11.21.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
  
    var titleList = [String]()
    var idList = [UUID]()
    
    var selectedTitle = ""
    var selectedId : UUID?
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    @objc func addButtonClicked() {
        selectedTitle = ""
        performSegue(withIdentifier: "toMapView", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    @objc func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            if results.count > 0 {
                self.titleList.removeAll()
                self.idList.removeAll()
                
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        self.titleList.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idList.append(id)
                    }
                    tableView.reloadData()
                }
            }
        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = titleList[indexPath.row]
        selectedId = idList[indexPath.row]
        performSegue(withIdentifier: "toMapView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapView" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = selectedTitle
            destinationVC.selectedId = selectedId
        }
    }
    

}
