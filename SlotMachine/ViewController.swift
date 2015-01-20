//
//  ViewController.swift
//  SlotMachine
//
//  Created by Joshua Robins on 1/14/15.
//  Copyright (c) 2015 Pawswin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Create UIViews in code vs storyboard
    var firstContainer: UIView! // implicit unwrapped optionals, not yet initialized
    var secondContainer: UIView!
    var thirdContainer: UIView!
    var fourthContainer: UIView!
    
    var titleLabel: UILabel!
    
    // Information Labels
    var creditsLabel: UILabel!
    var betLabel: UILabel!
    var winnerPaidLabel: UILabel!
    var creditsTitleLabel: UILabel!
    var betTitleLabel: UILabel!
    var winnerPaidTitleLabel: UILabel!
    
    // Buttons for fourthContainer
    var resetButton: UIButton!
    var betOneButton: UIButton!
    var betMaxButton: UIButton!
    var spinButton: UIButton!
    
    var slots:[[Slot]] = []
    
    // Tracks user's stats
    var credits = 0
    var currentBet = 0
    var winnings = 0
    
    // "k" is typical coding to tell us a property is a constant
    
    let kMarginForView: CGFloat = 10.0 // CGFloat type is double or float
    let kMarginForSlot: CGFloat = 2.0
    
    let kSixth: CGFloat = 1.0/6.0
    let kThird: CGFloat = 1.0/3.0
    let kHalf: CGFloat = 1.0/2.0
    let kEighth: CGFloat = 1.0/8.0
    
    let kNumberOfContainers = 3 // Represents columns on slot machine
    let kNumberOfSlots = 3 // Represents rows on slot machine
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupContainerViews() // Draws all background containers
        setupFirstContainer(self.firstContainer)
        setupThirdContainer(self.thirdContainer)
        setupFourthContainer(self.fourthContainer)
        
        hardReset()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    func resetButtonPressed (button: UIButton) {
        
        hardReset()
        
    }
    
    func betOneButtonPressed (button: UIButton) {
        
        if credits <= 0 {
            showAlertWithText(header: "No More Credits", message: "Reset Game")
        }
        else {
            if currentBet < 5 {
                currentBet += 1
                credits -= 1
                updateMainView() // Updates our user stats labels
            }
            else { // Max bet of 5
                showAlertWithText(message: "You can only bet 5 credits at one time!")
            }
        }
        
    }
    
    func betMaxButtonPressed (button: UIButton) {
        
        if credits <= 5 {
            showAlertWithText(header: "Not Enough Credits", message: "Bet a Lower Amount")
        }
        else {
            if currentBet < 5 {
                var creditsToBetMax = 5 - currentBet
                credits -= creditsToBetMax
                currentBet += creditsToBetMax
                updateMainView()
            }
            else {
                showAlertWithText(message: "You can only bet 5 credits at one time!")
            }
        }
        
    }
    
    func spinButtonPressed (button: UIButton) {
        
        // Remove the slot images first to free up memory
        removeSlotImageViews()
        
        // Generates and Displays a new set of slots
        slots = Factory.createSlots()
        setupSecondContainer(self.secondContainer)
        
        var winningsMultiplier = SlotBrain.computeWinnings(slots)
        winnings = winningsMultiplier * currentBet
        currentBet = 0
        credits += winnings
        updateMainView()
        
    }
    
    func setupContainerViews() {
        
        // Create and Add first container
        self.firstContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: self.view.bounds.origin.y, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth)) // the height will now be 1/6 its super-view frame
        self.firstContainer.backgroundColor = UIColor.blueColor()
        self.view.addSubview(self.firstContainer) // draws firstContainer
        
        // Create and Add second container
        self.secondContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * (3 * kSixth))) // "Y" location is based on firstContainer's frame height to line up right below it
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.secondContainer)
        
        // Create and Add third container
        self.thirdContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height + secondContainer.frame.height, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.grayColor()
        self.view.addSubview(self.thirdContainer)
        
        // Create and Add fourth container
        self.fourthContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height + secondContainer.frame.height + thirdContainer.frame.height, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth))
        self.fourthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.fourthContainer)
        
    }
    
    func setupFirstContainer(containerView: UIView) {
        
        self.titleLabel = UILabel()
        self.titleLabel.text = "Super Slots"
        self.titleLabel.textColor = UIColor.yellowColor()
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40) // Display font and size
        self.titleLabel.sizeToFit() // Resizes the label to FIT the font
        self.titleLabel.center = containerView.center // Centers the label in the container
        containerView.addSubview(self.titleLabel)
        
    }
    
    func setupSecondContainer(containerView: UIView) {

        for var containerNumber = 0; containerNumber < kNumberOfContainers; containerNumber++ {

            for var slotNumber = 0; slotNumber < kNumberOfSlots; slotNumber++ {
                
                var slot:Slot
                var slotImageView = UIImageView()
                                
                // Looks in our global slots array, see if slots have previously been generated
                if slots.count != 0 {
                    let slotContainer = slots[containerNumber] // Finds which column
                    slot = slotContainer[slotNumber] // Finds which slot in the column
                    slotImageView.image = slot.image
                }
                else {
                    slotImageView.image = UIImage(named: "Ace")
                }
                
                slotImageView.backgroundColor = UIColor.yellowColor()
                slotImageView.frame = CGRect(x: containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(containerNumber) * kThird), y: containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(slotNumber) * kThird), width: containerView.bounds.width * kThird - kMarginForSlot, height: containerView.bounds.height * kThird - kMarginForSlot)
                containerView.addSubview(slotImageView)
                
            }
        }
    }
    
    func setupThirdContainer(containerView: UIView) {
        
        self.creditsLabel = UILabel()
        self.creditsLabel.text = "000000"
        self.creditsLabel.textColor = UIColor.blueColor()
        self.creditsLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.creditsLabel.sizeToFit()
        self.creditsLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird) // Sets the center point of the button to the coordinates
        self.creditsLabel.textAlignment = NSTextAlignment.Center // Centers the text in the frame
        self.creditsLabel.backgroundColor = UIColor.lightGrayColor()
        containerView.addSubview(self.creditsLabel)
        
        self.betLabel = UILabel()
        self.betLabel.text = "0000"
        self.betLabel.textColor = UIColor.blueColor()
        self.betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.betLabel.sizeToFit()
        self.betLabel.center = CGPoint(x: containerView.frame.width * 3 * kSixth, y: containerView.frame.height * kThird) // Sets the center point of the button to the coordinates
        self.betLabel.textAlignment = NSTextAlignment.Center // Centers the text in the frame
        self.betLabel.backgroundColor = UIColor.lightGrayColor()
        containerView.addSubview(self.betLabel)
        
        self.winnerPaidLabel = UILabel()
        self.winnerPaidLabel.text = "000000"
        self.winnerPaidLabel.textColor = UIColor.blueColor()
        self.winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.winnerPaidLabel.sizeToFit()
        self.winnerPaidLabel.center = CGPoint(x: containerView.frame.width * 5 * kSixth, y: containerView.frame.height * kThird) // Sets the center point of the button to the coordinates
        self.winnerPaidLabel.textAlignment = NSTextAlignment.Center // Centers the text in the frame
        self.winnerPaidLabel.backgroundColor = UIColor.lightGrayColor()
        containerView.addSubview(self.winnerPaidLabel)
        
        self.creditsTitleLabel = UILabel()
        self.creditsTitleLabel.text = "Credit Amount"
        self.creditsTitleLabel.textColor = UIColor.blackColor()
        self.creditsTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 12)
        self.creditsTitleLabel.sizeToFit()
        self.creditsTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * 2 * kThird) // Sets the center point of the button to the coordinates
        self.creditsTitleLabel.textAlignment = NSTextAlignment.Center // Centers the text in the frame
        containerView.addSubview(self.creditsTitleLabel)
        
        self.betTitleLabel = UILabel()
        self.betTitleLabel.text = "Bet Amount"
        self.betTitleLabel.textColor = UIColor.blackColor()
        self.betTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 12)
        self.betTitleLabel.sizeToFit()
        self.betTitleLabel.center = CGPoint(x: containerView.frame.width * 3 * kSixth, y: containerView.frame.height * 2 * kThird) // Sets the center point of the button to the coordinates
        self.betTitleLabel.textAlignment = NSTextAlignment.Center // Centers the text in the frame
        containerView.addSubview(self.betTitleLabel)
        
        self.winnerPaidTitleLabel = UILabel()
        self.winnerPaidTitleLabel.text = "Winner Paid"
        self.winnerPaidTitleLabel.textColor = UIColor.blackColor()
        self.winnerPaidTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 12)
        self.winnerPaidTitleLabel.sizeToFit()
        self.winnerPaidTitleLabel.center = CGPoint(x: containerView.frame.width * 5 * kSixth, y: containerView.frame.height * 2 * kThird) // Sets the center point of the button to the coordinates
        self.winnerPaidTitleLabel.textAlignment = NSTextAlignment.Center // Centers the text in the frame
        containerView.addSubview(self.winnerPaidTitleLabel)
        
    }
    
    func setupFourthContainer (containerView: UIView) {
        
        self.resetButton = UIButton()
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12) // Question mark states that the titleLabel may or may not exist
        self.resetButton.backgroundColor = UIColor.lightGrayColor()
        self.resetButton.sizeToFit()
        self.resetButton.center = CGPoint(x: containerView.frame.width * kEighth, y: containerView.frame.height * kHalf)
        self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // the ":" specifies that there is at least 1 parameter that needs to be passed through to resetButtonPressed
        containerView.addSubview(self.resetButton)
        
        self.betOneButton = UIButton()
        self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betOneButton.backgroundColor = UIColor.greenColor()
        self.betOneButton.sizeToFit()
        self.betOneButton.center = CGPoint(x: containerView.frame.width * 3 * kEighth, y: containerView.frame.height * kHalf)
        self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betOneButton)
        
        self.betMaxButton = UIButton()
        self.betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betMaxButton.backgroundColor = UIColor.redColor()
        self.betMaxButton.sizeToFit()
        self.betMaxButton.center = CGPoint(x: containerView.frame.width * 5 * kEighth, y: containerView.frame.height * kHalf)
        self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betMaxButton)
        
        self.spinButton = UIButton()
        self.spinButton.setTitle("Spin!", forState: UIControlState.Normal)
        self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.spinButton.backgroundColor = UIColor.greenColor()
        self.spinButton.sizeToFit()
        self.spinButton.center = CGPoint(x: containerView.frame.width * 7 * kEighth, y: containerView.frame.height * kHalf)
        self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.spinButton)
        
    }
    
    func removeSlotImageViews() {
        
        // Only run if secondContainer exists
        if self.secondContainer != nil {
            let container:UIView? = self.secondContainer
            let subViews: Array? = container!.subviews
            for view in subViews! {
                view.removeFromSuperview()
            }
        }
        
    }
    
    func hardReset() {
        
        removeSlotImageViews()
        
        slots.removeAll(keepCapacity: true) // Removes the elements from the array, but keeps the same size
        self.setupSecondContainer(self.secondContainer)
        
        // Reset the user's statistics
        self.credits = 50
        self.currentBet = 0
        self.winnings = 0
        updateMainView()
        
    }
    
    func updateMainView() {
        
        self.creditsLabel.text = "\(credits)"
        self.betLabel.text = "\(currentBet)"
        self.winnerPaidLabel.text = "\(winnings)"
        
    }
    
    func showAlertWithText (header: String = "Warning", message: String) {
        // Initially set the header, gives us a default option
        // Can be overridden or can be ignored
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert) // Creates an alert instance
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)) // Gives the user a way to dismiss the alert
        self.presentViewController(alert, animated: true, completion: nil) // Displays the alert, does not require an action after it is dismissed
        
    }
    
    
    
    
}

