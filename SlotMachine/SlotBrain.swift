//
//  SlotBrain.swift
//  SlotMachine
//
//  Created by Joshua Robins on 1/14/15.
//  Copyright (c) 2015 Pawswin. All rights reserved.
//

import Foundation
import UIKit

class SlotBrain {
    
    class func unpackSlotsIntoSlotRows (slots: [[Slot]]) -> [[Slot]] {
        
        var slotRow1: [Slot] = []
        var slotRow2: [Slot] = []
        var slotRow3: [Slot] = []
        
        for slotArray in slots {
            
            for var i = 0; i < slotArray.count; i++ {
                
                let slot = slotArray[i]
                if i == 0 {
                    slotRow1.append(slot)
                }
                else if i == 1 {
                    slotRow2.append(slot)
                }
                else if i == 2 {
                    slotRow3.append(slot)
                }
                else {
                    println("Error: Invalid Slot")
                }
                
            }
            
        }
        
        var slotsInRows: [[Slot]] = [slotRow1, slotRow2, slotRow3]
        return slotsInRows
        
    }
    
    class func computeWinnings (slots: [[Slot]]) -> Int {
        
        var slotsInRows = unpackSlotsIntoSlotRows(slots)
        var winnings = 0
        
        var flushWinCount = 0
        var threeOfKindWinCount = 0
        var straightWinCount = 0
        
        for slotRow in slotsInRows {
            
            if checkFlush(slotRow) == true {
                // Determines we have a flush for this particular row of slots
                println("flush")
                winnings += 1
                flushWinCount += 1
            }
            
            if checkThreeInRow(slotRow) == true {
                println("three in a row")
                winnings += 1
                straightWinCount += 1
            }
            
            if checkThreeOfKind(slotRow) == true {
                println("three of a kind")
                winnings += 1
                threeOfKindWinCount += 1
            }
            
        }
        
        if flushWinCount == 3 {
            println("Royal Flush")
            winnings += 15
        }

        if straightWinCount == 3 {
            println("Epic Straight")
            winnings += 1000
        }
        
        if threeOfKindWinCount == 3 {
            println("Impossible!")
            winnings += 50
        }
        
        return winnings
        
    }
    
    class func checkFlush (slotRow: [Slot]) -> Bool {
        
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if slot1.isRed == true && slot2.isRed == true && slot3.isRed == true {
            return true
        }
        else if slot1.isRed == false && slot2.isRed == false && slot3.isRed == false {
            return true
        }
        else {
            return false
        }
        
    }
    
    class func checkThreeInRow (slotRow: [Slot]) -> Bool {
        
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if slot1.value == slot2.value - 1 && slot1.value == slot3.value - 2 {
            return true
        }
        else if slot1.value == slot2.value + 1 && slot1.value == slot3.value + 2 {
            return true
        }
        else {
            return false
        }
        
    }
    
    class func checkThreeOfKind (slotRow: [Slot]) -> Bool {
        
        let slot1 = slotRow[0]
        let slot2 = slotRow[1]
        let slot3 = slotRow[2]
        
        if slot1.value == slot2.value && slot1.value == slot3.value {
            return true
        }
        else {
            return false
        }
        
    }
    
    
    
    
    
    
}