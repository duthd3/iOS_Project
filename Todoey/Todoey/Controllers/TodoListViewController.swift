//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var titleLabel: String = "Todo"
    
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
           loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //AppDelegate에 있는 persistContainer에 대한 참조
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        self.title = titleLabel
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
       
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //context.delete(itemArray[indexPath.row]) //context는 임시공간(영구 데이터 소스에서 데이터 제거)
        //itemArray.remove(at: indexPath.row) //단지 테이블 뷰를 채우는 데 사용되는 itemArray 업데이트(테이블 뷰 데이터 소스 로드하는데 사용, 순서중요 먼저 데이터베이스 컨텍스트에서 삭제 후 테이블 뷰 item을 삭제한다.) => 이후 save & commit & reload 까지 해줘야함.
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems() // save & commit 필요(영구 컨테이너) => reload()까지
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    //MARK: - Add New Items
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UIAlert
            
           
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem) //Create
            
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - model Manupulation Methods
    func saveItems() {
        
        do {
            try context.save() //데이터 저장(커밋)
        }catch {
           print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {//Read
  //      let request: NSFetchRequest<Item> = Item.fetchRequest() //Item entity에서 fetch요청(출력될 데이터 유형을 지정해야만 한다.)
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate]) //상위 카테고리의 이름을 가진 데이터를 뿌려줌. 검색 predicate도 적용
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate //상위 카테고리의 이름과 일치하는 카테고리의 data만 fetch
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
   
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)//[cd] 대소문자 분음부호 구분x, title에 어떤 문자열이 오던지 모두 포함
     
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // 결과는 title이 오름차순으로 정렬
        loadItems(with: request, predicate: predicate)

   
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}



