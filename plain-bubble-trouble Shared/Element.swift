//
//  Bubble.swift
//  plain-bubble-trouble iOS
//
//  Created by Morten Pedersen on 1/2/21.
//

import Foundation
import SpriteKit

class Element : SKSpriteNode {
    let label: Int
    let uuid: String
    var row: Int
    var col: Int
    
    //  override to allow integration with SpriteKit Scene Builder
    required init?(coder aDecoder: NSCoder) {
        // set dumb default values
        self.label = -1
        self.row = -1
        self.col = -1
        self.uuid = UUID().uuidString
        super.init(coder:aDecoder)
    }

    init(row:Int, col:Int, nLabels: Int, difficulty: Double, size: CGSize, position: CGPoint) {
        // get label and texture
        let tempLabel = Element.setLabel(row:row, col: col, nLabels: nLabels, difficulty: difficulty)
        let texture = SKTexture(imageNamed: "bubble\(tempLabel)")

        // set attrs
        self.label = tempLabel
        self.row = row
        self.col = col
        self.uuid = UUID().uuidString
        
        // init parent class
        super.init(texture: texture, color:SKColor.black, size: size)
        
        // set position, label, row, col
        self.position = position
        self.name = "element-\(self.uuid)"
    }
    
    
    class func setLabel(row:Int, col: Int, nLabels: Int, difficulty: Double) -> Int{
        if Double.random(in: 0.0..<1.0) <= difficulty {
            return Int( (row + col * 2) % 4 )
        } else {
            return Int( Double.random(in: 0...1) * Double(nLabels) )
        }
    }
}




