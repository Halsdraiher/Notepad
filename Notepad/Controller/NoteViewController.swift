//
//  NoteViewController.swift
//  Notepad
//
//  Created by Solovei Ihor on 18.04.2023.
//

import UIKit
import CoreData

class NoteViewController: UITableViewController {

    var previewArray = [Preview]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var index: Int?
    
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
        navigationItem.rightBarButtonItem?.isHidden = true
        noteText.becomeFirstResponder()
        
        noteTableView.backgroundColor = #colorLiteral(red: 0, green: 0.7844639421, blue: 0.7138563991, alpha: 1)
        noteText.backgroundColor = #colorLiteral(red: 0, green: 0.7844639421, blue: 0.7138563991, alpha: 1)
        
        noteText.delegate = self
        noteTableView.delegate = self
        noteTableView.dataSource = self
        
        loadNotes()
    }
    
    //MARK: - Save Data
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        previewArray[index!].previewText = noteText.text
        
        saveNotes()
    }
    
    
    //MARK: - Model Manupulation Methods
    
    func saveNotes() {
        navigationItem.rightBarButtonItem?.isHidden = true
        noteText.endEditing(true)
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadNotes(with request: NSFetchRequest<Preview> = Preview.fetchRequest(), predicate: NSPredicate? = nil) {
        
        do {
            previewArray = try context.fetch(request)
            noteTitle.title = previewArray[index!].title
            noteText.text = previewArray[index!].previewText
            
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }

}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if noteText.text == previewArray[index!].previewText{
            navigationItem.rightBarButtonItem?.isHidden = true
        } else {
            navigationItem.rightBarButtonItem?.isHidden = false
        }
    }
}
