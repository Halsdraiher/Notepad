//
//  ViewController.swift
//  Notepad
//
//  Created by Solovei Ihor on 17.04.2023.
//

import UIKit
import CoreData

class PreviewController: UIViewController {
    
    var previewArray = [Preview]()
    var noteCell = NoteCell()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadPreviews()
        
    }
    
    //MARK: - Data Manipulating Methods
    
    func savePreviews() {

        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }

        self.tableView.reloadData()
    }

    func loadPreviews(with request: NSFetchRequest<Preview> = Preview.fetchRequest()) {

        do {
            previewArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }

        tableView.reloadData()

    }
    
    
    
    //MARK: - Add Button Pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Note", style: .default) { (action) in
            let newPreview = Preview(context: self.context)
            
            newPreview.title = textField.text!
            
            self.previewArray.append(newPreview)
            
            self.savePreviews()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new note"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

//MARK: - UITableViewDataSource

extension PreviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! NoteCell
        
        let preview = previewArray[indexPath.row]
        cell.titleLabel?.text = preview.title
        
        return cell
    }
    
}
