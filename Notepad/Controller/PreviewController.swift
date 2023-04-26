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
    let formatter = DateFormatter()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPreviews()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.reusableIdentifier)
        tableView.backgroundColor = UIColor(named: K.ColorSets.backColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPreviews()
    }
    
    //MARK: - Data Manipulating Methods
    // Save data to CoreData
    func savePreviews() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // Take data from CoreData
    func loadPreviews(with request: NSFetchRequest<Preview> = Preview.fetchRequest()) {
        
        do {
            previewArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add Button Pressed
    //Create alert for adding new note
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Note", style: .default) { (action) in
            let newPreview = Preview(context: self.context)
            
            newPreview.title = textField.text!
            newPreview.previewText = ""
            
            newPreview.createdAt = Date()
            self.formatter.dateFormat = "dd/MM/yyyy"
            let dateString = self.formatter.string(from: newPreview.createdAt!)
            newPreview.creationDate = dateString
            
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

extension PreviewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableIdentifier, for: indexPath) as! NoteCell
        
        let preview = previewArray[indexPath.row]
        cell.titleLabel?.text = preview.title
        cell.noteText?.text = preview.previewText
        cell.creationDate?.text = preview.creationDate
       
        return cell
    }
    
    // Use swipe action for row method
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
                let currentTitle = self.previewArray[indexPath.row]
                alertTextField.text = currentTitle.title
                textField = alertTextField
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, change])
        
    }
    
}

//MARK: - UITableViewDelegate

extension PreviewController: UITableViewDelegate {
    // Segue to NoteViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueInentifier, sender: self)
        
        savePreviews()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // Prepare NoteViewController to loading
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NoteViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPreview = previewArray[indexPath.row]
            destinationVC.noteText.text = previewArray[indexPath.row].previewText
        }
    }
    
}
