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
    @IBOutlet weak var noteText: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(named: K.ColorSets.backColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
}
