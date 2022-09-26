//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Hugo‘s system on 9/25/22.
//

import UIKit

class CreationViewController: UIViewController {
    
    // this is a way to connect the main view controller
    // flashcardsController is the name
    // viewController is the class type
    var flashcardsController: ViewController!
    
    @IBOutlet weak var Question: UITextField!
    @IBOutlet weak var Answer1: UITextField!
    @IBOutlet weak var Answer2: UITextField!
    @IBOutlet weak var Answer3: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func disTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        
        // Get the text in the question text field
        let questionText = Question.text
        
        // Get the text in the answer text field
        let answer1Text = Answer1.text
        let answer2Text = Answer2.text
        let answer3Text = Answer3.text
        
        // Call the function to update the flashcard
        flashcardsController.updateFlashcard(question: questionText!, answer1: answer1Text!, answer2: answer2Text!, answer3: answer3Text!)
        
        
        // Dismiss
        dismiss(animated: true)
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
