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
    var xIndex, yIndex: Int
    var xPos, yPos: Double
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(nLabels: Int, xIndex: Int, yIndex:Int, difficulty: Double, boundary: Boundary) {
        self.xIndex = xIndex
        self.yIndex = yIndex
        
        xPos = boundary.left + Double(xIndex) * boundary.cellWidth
        yPos = boundary.bottom + Double(yIndex) * boundary.cellHeight
        
        label = Element.setLabel(xIndex:xIndex, yIndex: yIndex, nLabels: nLabels, difficulty: difficulty)
    }
    
    
    static func setLabel(xIndex:Int, yIndex: Int, nLabels: Int, difficulty: Double) -> Int{
        if Double.random(in: 0.0..<1.0) <= difficulty {
            return Int( (xIndex + yIndex * 2) % 4 )
        } else {
            return Int( Double.random(in: 0...1) * Double(nLabels) )
        }
    }
    
    func getSKNodeName() -> String{
        return "element[\(label),\(xIndex),\(yIndex)]"
    }
    
    func getSKSpriteNode() -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "bubble\(label)")
        node.name = getSKNodeName()
        node.position = CGPoint(x: xPos, y:yPos)
        return node
    }
    
}

extension Element: Equatable {
    static func == (lhs: Element, rhs: Element) -> Bool {
        return lhs.label == rhs.label &&
            lhs.xIndex == rhs.xIndex &&
            lhs.yIndex == rhs.yIndex
    }
}




