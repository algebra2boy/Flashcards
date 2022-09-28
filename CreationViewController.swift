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
    
    // the editing part (? because we are not sure if they are nil)
    var initialQuestion: String?
    var initialAnswer1: String?
    var initialAnswer2: String?
    var initialAnswer3: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Question.text = initialQuestion
        Answer1.text = initialAnswer1
        Answer2.text = initialAnswer2
        Answer3.text = initialAnswer3
        
        
    }
    
    @IBAction func disTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        
        // Get the text in the question text field
        guard let questionText = Question.text else {return}
        
        // Get the text in the answer text field
        guard let answer1Text = Answer1.text else {return}
        guard let answer2Text = Answer2.text else {return}
        guard let answer3Text = Answer3.text else {return}
        
        // if any of the text field is empty and alert them
        if (questionText.isEmpty || answer1Text.isEmpty || answer2Text.isEmpty || answer3Text.isEmpty){
            // customize the alert
            let alert = UIAlertController(title: "Missing Text Field", message: "Please try to complete all the text field", preferredStyle:.alert)
            
            // add ok button to dismiss the screen
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            
            // display the alert
            present(alert, animated: true)
        }else{
            // Call the function to update the flashcard
            flashcardsController.updateFlashcard(question: questionText, answer1: answer1Text, answer2: answer2Text, answer3: answer3Text)
            // Dismiss
            dismiss(animated: true)
        }
        
        
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
