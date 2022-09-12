//
//  ViewController.swift
//  Flashcards
//
//  Created by Hugo‘s system on 9/11/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func disTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
}

