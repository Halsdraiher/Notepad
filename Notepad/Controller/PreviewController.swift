//
//  ViewController.swift
//  Notepad
//
//  Created by Solovei Ihor on 17.04.2023.
//

import UIKit

class PreviewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NoteCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    
    }

}

//MARK: - UITableViewDataSource

extension PreviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        return cell
    }
    
    
}
