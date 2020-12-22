//
//  BackEnd.swift
//  plain-bubble-trouble iOS
//
//  Created by Morten Pedersen on 12/21/20.
//

import Foundation


// GameBoard
class Board {
    let xLenght:Int = 10
    let yLenght:Int = 10
    var board = [BoardElement]()

        
    func initializeBoard ()
    {
        var y = self.yLenght
        var x = self.yLenght
        
        while y >= 0 {
            while x >= 0 {
                x -= 1
            }
            y -= 1
        }
    }
    
    func putBoardElement (xloc:Int, yloc:Int, level:Int)
    {
        switch level {
        case 1..<5:
            BoardElement(xLoc, yLoc)//.assignLabel(n_labels:4, difficulty:0.8)
        case 6..<10:
            BoardElement(xLoc, yLoc)//.assignLabel(n_labels:5, difficulty:0.7)
        default:
            BoardElement(xLoc, yLoc)//.assignLabel(n_labels:6, difficulty:0.6)
        }
    
    }
        
}


class BoardElement {
    var label: Int = 0
    var isActive: Bool = false
    let xLoc: Int = 0
    let yLoc: Int = 0
    
    
    func assignLabel(n_labels: Int) -> Int {
        var digit = Int.random(in: 0...n_labels)
        return digit
    }
}





