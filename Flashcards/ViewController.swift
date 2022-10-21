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
    @IBOutlet weak var addButton: UIButton!
    
    // Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    // Current flashcard index
    var currentIndex = 0
    
    var tapped = true
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // First start with the flashcard invisible and slightly smaller in size
        // alpha level is transparent level
        card.alpha = 0.0
        Button1.alpha = 0.0
        Button2.alpha = 0.0
        Button3.alpha = 0.0
        nextButton.alpha = 0.0
        prevButton.alpha = 0.0
        addButton.alpha = 0.0
        
        // set the card property by 75% on the x and y scale
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        Button1.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        Button2.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        Button3.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        nextButton.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        prevButton.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        addButton.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        
        // the 0.75 x 0.75 % card suddenly expands from a small card to a huge card
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, animations: {
            // make the card totally visible
            self.card.alpha = 1.0
            self.Button1.alpha = 1.0
            self.Button2.alpha = 1.0
            self.Button3.alpha = 1.0
            self.nextButton.alpha = 1.0
            self.prevButton.alpha = 1.0
            self.addButton.alpha = 1.0
            
            // actually shrhink the card
            self.card.transform = CGAffineTransform.identity
            self.Button1.transform = CGAffineTransform.identity
            self.Button2.transform = CGAffineTransform.identity
            self.Button3.transform = CGAffineTransform.identity
            self.nextButton.transform = CGAffineTransform.identity
            self.prevButton.transform = CGAffineTransform.identity
            self.addButton.transform = CGAffineTransform.identity
        })
    }
    
    
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
        flipFlashcard()
    }
    
    /*
     Animation part!!!!
     */
    
    func flipFlashcard() {
        // when we use a closure we're required to use self.
        // adding animation to flip the card
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.frontLabel.isHidden = self.tapped
            self.tapped = !self.tapped
        })
        
    }
    
    /// create special transition effect when switch to the next card
    func animateCardRightOut() {
        // move the card 500 points to the left and make y-axis constant
        // animatins: move the card off the screen
        // completion: after the card is off the screen, load the current card to the next card
        UIView.animate(withDuration: 0.5, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -500.0, y: 0.0)
        }, completion: { finished in
            
            // update labels only after the card is off the screen
            // Update labels
            self.updateLabels()
            
            // Run other animation
            self.animateCardRightIn()
        })
    }
    
    // reset the transform to have no transform, meaning we want to set it to the identity transform
    func animateCardRightIn() {
        
        // Start on the right side (don't animate this)
        // set the card's new position to the original position
        card.transform = CGAffineTransform.identity.translatedBy(x: 500.0, y: 0.0)
        
        // Animate card to its original position
        UIView.animate(withDuration: 0.5, animations: {
            self.card.transform = CGAffineTransform.identity
        })
    
    }
    
    /// create special transition effect when switch to the previous card
    func animateCardLeftOut() {
        // move the card 500 points to the right and make y-axis constant
        // animatins: move the card off the screen
        // completion: after the card is off the screen, load the current card to the previous card
        UIView.animate(withDuration: 0.5, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -500.0, y: 0.0)
        }, completion: { finished in
            
            // update labels only after the card is off the screen
            // Update labels
            self.updateLabels()
            
            // Run other animation
            self.animateCardLeftIn()
        })
    }
    
    // reset the transform to have no transform, meaning we want to set it to the identity transform
    func animateCardLeftIn() {
        
        // Start on the left side (don't animate this)
        // set the card's new position to the original position
        card.transform = CGAffineTransform.identity.translatedBy(x: -500.0, y: 0.0)
        
        // Animate card to its original position
        UIView.animate(withDuration: 0.5, animations: {
            self.card.transform = CGAffineTransform.identity
        })
    
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
        frontLabel.isHidden = false
        Button1.isHidden = false
        Button2.isHidden = false
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
        
        // Update buttons
        updateNextPrevButtons()
        
        // Animation on card
        animateCardLeftOut()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        // Increase current index
        currentIndex = currentIndex + 1
        
        // Update buttons
        updateNextPrevButtons()
        
        // add special animation
        animateCardRightOut()
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
