//
//  Bubble.swift
//  plain-bubble-trouble iOS
//
//  Created by Morten Pedersen on 1/2/21.
//

import Foundation
import SpriteKit

class Element {
    let label: Int
    var row, col: Int
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(row: Int, col:Int, nLabels: Int, difficulty: Double) {
        self.row = row
        self.col = col
        
        label = Element.setLabel(row:row, col: col, nLabels: nLabels, difficulty: difficulty)
    }
    
    
    class func setLabel(row:Int, col: Int, nLabels: Int, difficulty: Double) -> Int{
        if Double.random(in: 0.0..<1.0) <= difficulty {
            return Int( (row + col * 2) % 4 )
        } else {
            return Int( Double.random(in: 0...1) * Double(nLabels) )
        }
    }
    
    func getSKNodeName() -> String{
        return "element[\(label),\(row),\(col)]"
    }
    
    func getSKSpriteNode(pos: CGPoint, size: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "bubble\(label)")
        node.name = getSKNodeName()
        node.size = size
        node.position = pos
        return node
    }
    
}

extension Element: Equatable {
    static func == (lhs: Element, rhs: Element) -> Bool {
        return lhs.label == rhs.label &&
            lhs.row == rhs.col &&
            lhs.row == rhs.col
    }
}




