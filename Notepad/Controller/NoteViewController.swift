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
    
    var selectedPreview : Preview? {
        didSet {
            loadNotes()
        }
    }
    
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet var noteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.isHidden = true
        noteText.becomeFirstResponder()
        
        noteTableView.backgroundColor = UIColor(named: K.ColorSets.backColor)
        noteText.backgroundColor = UIColor(named: K.ColorSets.backColor)
        noteTitle.backgroundColor = UIColor(named: K.ColorSets.backColor)
        
        noteTitle.text = selectedPreview?.title
        
        noteTitle.delegate = self
        noteText.delegate = self
        noteTableView.delegate = self
        noteTableView.dataSource = self
        
        loadNotes()
    }
    
    //MARK: - Save changes
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        selectedPreview!.previewText = noteText.text
        selectedPreview!.title = noteTitle.text
        navigationItem.rightBarButtonItem?.isHidden = true
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
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }

}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if noteText.text == selectedPreview!.previewText {
            navigationItem.rightBarButtonItem?.isHidden = true
        } else {
            navigationItem.rightBarButtonItem?.isHidden = false
        }
    }
}

extension NoteViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if noteTitle.text == selectedPreview!.title {
            navigationItem.rightBarButtonItem?.isHidden = true
        } else {
            navigationItem.rightBarButtonItem?.isHidden = false
        }
    }
}
