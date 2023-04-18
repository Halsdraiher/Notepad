//
//  ViewController.swift
//  Notepad
//
//  Created by Solovei Ihor on 17.04.2023.
//

import UIKit

class PreviewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemPink.cgColor,
            UIColor.systemOrange.cgColor
        ]
        view.layer.addSublayer(gradientLayer)
    }


}

