//
//  ViewController.swift
//  Flashcards
//
//  Created by Hugo‘s system on 9/11/22.
//

import UIKit

struct Flashcard {
    var question: String
    var answer1 : String
    var answer2 : String
    var answer3 : String
}

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    
    @IBOutlet weak var card: UIView!
    
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    
    @IBOutlet weak var Reset: UIButton!
    @IBOutlet weak var Congrats: UILabel!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var deleteButton: UIView!
    
    // Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    // Current flashcard index
    var currentIndex = 0
    
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
        
        // Read/load saved flashcards
        readSavedFlashcards()
        
        // Adding our initial flashcard if needed (in case this is the first time user is using the app or have not put any new card )
        if flashcards.count == 0 {
            updateFlashcard(question: "What is the chemical formula of water?",
                            answer1: "CO2",
                            answer2: "H2O",
                            answer3: "NH3",
                            isExisting: false)
        } else { // we know there exists at least one card
            updateLabels()
            updateNextPrevButtons()
        }
        
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
    func updateFlashcard(question: String, answer1: String, answer2: String, answer3: String, isExisting: Bool) {
        let flashcard = Flashcard(question: question,
                                  answer1: answer1,
                                  answer2: answer2,
                                  answer3: answer3)
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer2
        
        if isExisting {
            // Replace/edit existing flashcard
            flashcards[currentIndex] = flashcard
        }else {
            // Adding flashcard to the end of flashcards array
            flashcards.append(flashcard)
            print("Added a new Flashcard, take a look -> ", flashcard)
            
            // Logging to the console
            print("😄 Added new flashcard")
            print("😄 We not have \(flashcards.count) flashcards")
            
            // Update current index
            currentIndex = flashcards.count - 1
            print("😄 Our current index is \(currentIndex)")
            
            // Update buttons
            updateNextPrevButtons()
            
            Button1.setTitle(answer1, for: .normal)
            Button2.setTitle(answer2, for: .normal)
            Button3.setTitle(answer3, for: .normal)
        }
        // save our added flashcard to the disk
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons() {
        
        // Disable next button if at the end
        if currentIndex == flashcards.count-1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        // Disable prev button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We know the destination of the segue is the Navigation Controller
        let navigationController = segue.destination as! UINavigationController
        
        // We know the Navigation Controller only contains a Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        // We set the flashcardsController property to self
        creationController.flashcardsController = self
        
        // transfer the existing flashcard information the creationview controller
        if (segue.identifier == "EditSegue") {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer1 = Button1.titleLabel?.text
            creationController.initialAnswer2 = Button2.titleLabel?.text
            creationController.initialAnswer3 = Button3.titleLabel?.text
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        // decrease current index
        currentIndex = currentIndex - 1
        
        // update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        // Increase current index
        currentIndex = currentIndex + 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
    }
    
    func updateLabels() {
        
        // get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer2
        
        // update Buttons
        Button1.setTitle(currentFlashcard.answer1, for: .normal)
        Button2.setTitle(currentFlashcard.answer2, for: .normal)
        Button3.setTitle(currentFlashcard.answer3, for: .normal)
    }
    
    /// save flashcard data to disk every time our flashcard array changes
    func saveAllFlashcardsToDisk() {
        
        // From flashcard array to dictionary array (flashcard array -> dictionary )
        // it is like a closure with for-each loop
        // [question: answer]
        let dictionaryArray = flashcards.map { (card) -> [String : String] in
            return ["question" : card.question,
                    "answer1" :  card.answer1,
                    "answer2" :  card.answer2,
                    "answer3" :  card.answer3]
        }
        
        // Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // Log it
        print ("🔥 Flashcards saved to UserDefaults")
    }
    
    /// Reading from disk to retrieve previous flashcards
    func readSavedFlashcards() {
        
        // Read dictionary array from disk (if any)
        // we are not sure whether the disk has any flashcard, so we put ? to indicate uncertainty
        // dictionaryArray can only be used if and only if it exists at the first place
        // if disk does not store anything, this if elsement would not be executed
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            
            // In here we know for sure we have a dictionary array
            // We convert a dictionary array to flashcard array (opposite of saveAllFlashcardsDisk())
            // (dictionary -> flashcard array )
            // ! is telling Swift that it is 100% that the value is there
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!,
                                 answer1: dictionary["answer1"]!,
                                 answer2 : dictionary["answer2"]!,
                                 answer3 : dictionary["answer3"]!)
            }
            
            // Put all these saved cards in our flashcard array
            flashcards.append(contentsOf: savedCards)
            
            
        }
        
        
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        print("Button has been pressed")
        // show confirmation
        let alert = UIAlertController(title: "Delete Flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        
        // make Cancel and Delete Button
        // adding our internal logic to delete the flashcard
        let deletionAction = UIAlertAction(title: "Delete",
                                           style: .destructive) {action in self.deleteCurrentFlashcard()}
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // add Cancel and Delete Button onto the alert controller
        alert.addAction(deletionAction)
        alert.addAction(cancelAction)
        
        // display the alert
        present(alert, animated: true)
    }
    
    func deleteCurrentFlashcard() {
        
        if flashcards.count == 1 {
            let alert = UIAlertController(title: "Do not delete the first flashcard", message: "Please do not do this", preferredStyle:.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            
            // display the alert
            present(alert, animated: true)
            return
        }
        
        // Delete current
        flashcards.remove(at: currentIndex)
        
        // Special case: Check if last card was deleted
        // if we have 4 cards (at index 0,1,2 and 3), and the currentIndex is 3, and we choose to delete that one, the flashcards array will end up with only 3 elements (index 0,1 and 2), but the currentIndex would still be 3.
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
        }
        
        // update next and prev Button
        updateNextPrevButtons()
        
        // update Labels
        updateLabels()
        
        // save new flashcard data on disk
        saveAllFlashcardsToDisk()
    }
}

