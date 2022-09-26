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
    
    @IBOutlet weak var card: UIView!
    
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    
    @IBOutlet weak var Reset: UIButton!
    @IBOutlet weak var Congrats: UILabel!
    
    
    @IBOutlet weak var ResetButton: UIButton!
    
    var tapped = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // set up the corner radius
        card.layer.cornerRadius = 20.0
        card.clipsToBounds = true
        card.layer.shadowRadius = 50
        card.layer.shadowOpacity = 0.8
        card.clipsToBounds = true
        
        Button1.layer.cornerRadius = 20.0
        Button1.clipsToBounds = true
        Button1.layer.borderWidth = 3.0
        Button1.layer.borderColor = UIColor.red.cgColor
        
        Button2.layer.cornerRadius = 20.0
        Button2.clipsToBounds = true
        Button2.layer.borderWidth = 3.0
        Button2.layer.borderColor = UIColor.red.cgColor
        
        Button3.layer.cornerRadius = 20.0
        Button3.clipsToBounds = true
        Button3.layer.borderWidth = 3.0
        Button3.layer.borderColor = UIColor.red.cgColor
        
        Congrats.isHidden = true
        

    }

    @IBAction func disTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = tapped
        tapped = !tapped
    }
    
    @IBAction func didTapOne(_ sender: Any) {
        Button1.isHidden = true
    }
    
    @IBAction func didTapTwo(_ sender: Any) {
        frontLabel.isHidden = tapped
        tapped = !tapped
        Congrats.isHidden = false
    }
    
    @IBAction func didTapThree(_ sender: Any) {
        Button3.isHidden = true
    }
    
    
    @IBAction func ResetToOrgin(_ sender: Any) {
        Congrats.isHidden = true
        sleep(1)
        frontLabel.isHidden = false
        sleep(1)
        Button1.isHidden = false
        sleep(1)
        Button2.isHidden = false
        sleep(1)
        Button3.isHidden = false
    }
    func updateFlashcard(question: String, answer1: String, answer2: String, answer3: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We know the destination of the segue is the Navigation Controller
        let navigationController = segue.destination as! UINavigationController
        
        // We know the Navigation Controller only contains a Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        // We set the flashcardsController property to self
        creationController.flashcardsController = self
        
        
    }
}

