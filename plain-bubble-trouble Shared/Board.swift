////
////  BackEnd.swift
////  plain-bubble-trouble iOS
////
////  Created by Morten Pedersen on 12/21/20.
////
//
//import Foundation
//
//
//// GameBoard
//class Board {
//    let xLenght: Int = 10
//    let yLenght: Int = 10
//    var nLabels: Int = 4
//    var difficulity: Double = 0.4
//    var board: [[BoardElement?]]
//
//
//    init() {
//        self.board = self.initializeBoard()
//    }
//
//
//    func initializeBoard() -> Array<Array<BoardElement?>> {
//        var y = self.yLenght
//        var x = self.yLenght
//
//        while y >= 0 {
//            while x >= 0 {
//                self.board[x][y] = self.putBoardElement(xLoc: x, yLoc: y, level: 1)
//                x -= 1
//            }
//            y -= 1
//        }
//
//        return self.board
//    }
//
//
//    func putBoardElement (xLoc: Int, yLoc: Int, level: Int) -> BoardElement {
//        var boardelement: BoardElement
//        switch level {
//        case 1..<5:
//            boardelement = BoardElement(xLoc: xLoc, yLoc: yLoc, nLabels: 4, difficulty: 0.8)
//        case 6..<10:
//            boardelement = BoardElement(xLoc: xLoc, yLoc: yLoc, nLabels: 5, difficulty: 0.7)
//        default:
//            boardelement = BoardElement(xLoc: xLoc, yLoc: yLoc, nLabels: 6, difficulty: 0.6)
//        }
//
//        return boardelement
//    }
//
//    func onClick(xLoc: Int, yLoc: Int) {
//        // get label
//        // get active neighbours
//        // if less than 3 -> do nothing
//        // calculate score
//        // remove elements
//        // find elements to Move
//        // Move elements
//    }
//
//
//    func findElementstoDeactivate(xLoc: Int, yLoc: Int) {
//        //
//    }
//
//    func findElementsToMove() {
//        //
//    }
//
//    func moveElements() {
//        //
//    }
//
//    func removeElements() {
//
//    }
//
//    func calculateScore() {
//        //
//    }
//
//
//}
//
//
//class BoardElement {
//    var isActive: Bool = false
//    var label: Int?
//    var xLoc: Int?
//    var yLoc: Int?
//
//    init(xLoc: Int, yLoc: Int, nLabels: Int, difficulty: Double) {
//        self.xLoc = xLoc
//        self.yLoc = yLoc
//        self.activate(nLabels: nLabels)
//    }
//
//
//    func assignLabel(nLabels: Int) -> Int {
//        return Int.random(in: 0...nLabels)
//    }
//
//    func activate(nLabels: Int) {
//        self.isActive = true
//        self.label = self.assignLabel(nLabels: nLabels)
//    }
//
//    func deactivate() {
//        self.isActive = false
//        self.label = nil
//
//    }
//
//    func move(xLocStart: Int, xLocEnd: Int, yLocStart: Int, yLocEnd: Int) {
//
//    }
//}
//
//
//
//
//
