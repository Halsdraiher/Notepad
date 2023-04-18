//
//  NoteCell.swift
//  Notepad
//
//  Created by Solovei Ihor on 18.04.2023.
//

import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        noteView.layer.cornerRadius = noteView.frame.size.height / 10
        noteView.backgroundColor = UIColor.systemPink
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
}
