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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPreviews()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0.6070936322, blue: 0.588455379, alpha: 1)
        
        print(previewArray.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            newPreview.previewText = ""
            
            self.previewArray.append(newPreview)
            
            self.savePreviews()
        }
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
            
        }))
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new note"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
// Setup cell with [Preview] items
// Show PreviewView items on tableView


extension PreviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! NoteCell
        
        let preview = previewArray[indexPath.row]
        cell.titleLabel?.text = preview.title
        cell.noteText?.text = preview.previewText
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action for deleting row
        let delete = UIContextualAction (style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let noteToDelete = self.previewArray[indexPath.row]
            self.context.delete(noteToDelete)
            self.savePreviews()
            self.loadPreviews()
        }
        
        // Create swipe action for changing row Title
        let change = UIContextualAction (style: .normal, title: "Edit title") { (action, view, compilationHandler) in
            
            var textField = UITextField()
            
            // Create alert for input new Title text
            
            let alert = UIAlertController(title: "Change Title", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Done", style: .default) { (action) in
                let titleToChange = self.previewArray[indexPath.row]
                titleToChange.title = textField.text
                self.savePreviews()
                self.loadPreviews()
            }
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
                
            }))
            
            alert.addTextField { (alertTextField) in
                let oldTitle = self.previewArray[indexPath.row]
                alertTextField.text = oldTitle.title
                textField = alertTextField
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, change])
        
    }
    
}



//MARK: - UITableViewDelegate
// Segue to NoteViewController
// Prepare NoteViewController to loading

extension PreviewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNotes", sender: self)
        
        savePreviews()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NoteViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.index = indexPath.row
        }
    }
    
}
