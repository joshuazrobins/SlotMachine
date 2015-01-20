//
//  Factory.swift
//  SlotMachine
//
//  Created by Joshua Robins on 1/14/15.
//  Copyright (c) 2015 Pawswin. All rights reserved.
//

import Foundation
import UIKit

class Factory {
    
    class func createSlots() -> [[Slot]] {
        // class function, differs from instance (regular) functions
        // class functions operate on the class, regular functions operate on 1 instance of the class
        // since we do not need an instance of factory, just need to run the class (this will save memory)
        // cannot access class properties from a class function, must be created within the class function
        
        let kNumberOfSlots = 3
        let kNumberOfContainers = 3
        
        var slots: [[Slot]] = [] // Do not forget, only need one set of brackets because slots is just an array (of arrays)
        
        // Example:
        // slots = [ [slot1, slot2, slot3], [slot4, slot5, slot6], [slot7, slot8, slot9] ]
        // mySlotArray = slots[0] would return the first array from slots (variable type Array)
        // slot = mySlotArray[1] would return "slot2"
        
        for var containerNumber = 0; containerNumber < kNumberOfContainers; containerNumber++ {
            
            var slotArray:[Slot] = []
            
            for var slotNumber = 0; slotNumber < kNumberOfSlots; slotNumber++ {
                
                var slot = Factory.createSlot(slotArray)
                slotArray.append(slot)
                
            }
            
            slots.append(slotArray)
            
        }
        
        return slots
    }
    
    class func createSlot (currentCards: [Slot]) -> Slot {
        
        var currentCardValues:[Int] = []
        for slot in currentCards {
            // typical "for-in" loop where slot is initialized and type inferred via whatever array type currentCards is
            currentCardValues.append(slot.value)
        }
        
        var randomNumber = Int(arc4random_uniform(UInt32(13)))
        while contains(currentCardValues, randomNumber + 1) {
            // contains means it looks for second element in first element
            // "randomNumber+1" because numbers are generated 0-12, but our card values are 1-13
            randomNumber = Int(arc4random_uniform(UInt32(13)))
        }
        
        var slot:Slot
        
        switch randomNumber {
        case 0:
            slot = Slot(value: 1, image: UIImage(named: "Ace"), isRed: true)
        case 1:
            slot = Slot(value: 2, image: UIImage(named: "Two"), isRed: true)
        case 2:
            slot = Slot(value: 3, image: UIImage(named: "Three"), isRed: true)
        case 3:
            slot = Slot(value: 4, image: UIImage(named: "Four"), isRed: true)
        case 4:
            slot = Slot(value: 5, image: UIImage(named: "Five"), isRed: false)
        case 5:
            slot = Slot(value: 6, image: UIImage(named: "Six"), isRed: false)
        case 6:
            slot = Slot(value: 7, image: UIImage(named: "Seven"), isRed: true)
        case 7:
            slot = Slot(value: 8, image: UIImage(named: "Eight"), isRed: false)
        case 8:
            slot = Slot(value: 9, image: UIImage(named: "Nine"), isRed: false)
        case 9:
            slot = Slot(value: 10, image: UIImage(named: "Ten"), isRed: true)
        case 10:
            slot = Slot(value: 11, image: UIImage(named: "Jack"), isRed: false)
        case 11:
            slot = Slot(value: 12, image: UIImage(named: "Queen"), isRed: false)
        case 12:
            slot = Slot(value: 13, image: UIImage(named: "King"), isRed: true)
        default:
            slot = Slot(value: 0, image: UIImage(named: "Ace"), isRed: true)
        }
        
        return slot
    }
    
    
    
    
    
    
    
    
    
    
}