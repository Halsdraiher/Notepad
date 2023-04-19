//
//  NoteViewController.swift
//  Notepad
//
//  Created by Solovei Ihor on 18.04.2023.
//

import UIKit
import CoreData

class NoteViewController: UITableViewController {
    
    var noteArray = [Note]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedPreview : Preview? {
        didSet {
            loadNotes()
        }
    }
    
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var noteTitle: UINavigationItem!
    @IBOutlet var noteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTableView.delegate = self
        noteTableView.dataSource = self
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let newNote = Note(context: self.context)
        
        newNote.text = noteText.text
        self.saveNotes()
        self.loadNotes()
    }
    
    //MARK: - Model Manupulation Methods
    
    func saveNotes() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let notePredicate = NSPredicate(format: "parentCategory.title MATCHES %@", selectedPreview!.title!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [notePredicate, additionalPredicate])
        } else {
            request.predicate = notePredicate
        }
        
        do {
            noteArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    

}


