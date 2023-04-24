//
//  NoteCell.swift
//  Notepad
//
//  Created by Solovei Ihor on 18.04.2023.
//

import UIKit

class NoteCell: UITableViewCell {
    
    let previewArray = [Preview]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = #colorLiteral(red: 0, green: 0.7844639421, blue: 0.7138563991, alpha: 1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
}
