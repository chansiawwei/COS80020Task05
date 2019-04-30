//
//  ViewController.swift
//  Task05
//
//  Created by SIAW WEI CHAN on 15/4/19.
//  Copyright © 2019 SIAW WEI CHAN. All rights reserved.
//

import UIKit


struct ResponseData: Decodable {
    var person: [Person]
}
struct Person : Decodable {
    var name: String
    var age: String
    var employed: String
}

struct CellData{
    let name:String
    let age: String
    
}


class ViewController: UITableViewController,UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var table: UITableView!
    var people=[Person]()
    var filteredData=[CellData]()
    var isSeaching=false
    var arrayOfCellData=[CellData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.delegate=self
        searchBar.returnKeyType=UIReturnKeyType.done
        
        var result=loadJson(filename: "test")
      
        people.append(result![0])
        people.append(result![1])
         people.append(result![2])
        people.append(result![3])
        people.append(result![4])


        assignCellData(p: people)
       
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( isSeaching){
            return filteredData.count
        }
        return arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let text:String
        let cell=Bundle.main.loadNibNamed("CustomCellTableViewCell", owner: self, options: nil)?.first as! CustomCellTableViewCell
        cell.label1.text=arrayOfCellData[indexPath.row].name
        cell.label2.text=arrayOfCellData[indexPath.row].age
        
        if(isSeaching){
            
            cell.label1.text=filteredData[indexPath.row].name
            cell.label2.text=filteredData[indexPath.row].age
        }
        else{
            
            cell.label1.text=arrayOfCellData[indexPath.row].name
            cell.label2.text=arrayOfCellData[indexPath.row].age
            
        }
        
        return cell
    }
    
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text==nil || searchBar.text=="" ){
            isSeaching=false
            view.endEditing(true)
            table.reloadData()
        }
        else{
            isSeaching=true
            filteredData=arrayOfCellData.filter({$0.name == searchBar.text})
            table.reloadData()

        }
    }
    
    @IBOutlet weak var UIseg: UISegmentedControl!
    
    @IBAction func UIsegTapped(_ sender: Any) {
//        let cell=Bundle.main.loadNibNamed("CustomCellTableViewCell", owner: self, options: nil)?.first as! CustomCellTableViewCell
        let getIndex=UIseg.selectedSegmentIndex
        switch (getIndex) {
        case 0:
           //Sort by Name here
        people.sort { $0.name < $1.name }
            assignCellData(p: people)
        default:
            //Sort by Age here
            people.sort { $0.age < $1.age }
            assignCellData(p: people)
            
        }
        self.table.reloadData()

    }
    
  
    func assignCellData(p:[Person]){
        
        arrayOfCellData=[CellData(name:people[0].name, age:people[0].age),
                         CellData(name:people[1].name, age:people[1].age),
                         CellData(name:people[2].name, age:people[2].age),
        CellData(name:people[3].name, age:people[3].age),
        CellData(name:people[4].name, age:people[4].age)]
        
    }
    
    func loadJson(filename fileName: String) -> [Person]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.person
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
