//
//  Grid.swift
//  plain-bubble-trouble iOS
//
//  Created by Morten Pedersen on 1/5/21.
//

import Foundation
import SpriteKit

class Grid:SKSpriteNode {
    var rows:Int!
    var cols:Int!
    var blockSize:CGFloat!

    convenience init?(blockSize:CGFloat, rows:Int, cols:Int) {
        guard let texture = Grid.gridTexture(blockSize: blockSize, rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.black, size: texture.size())
        self.blockSize = blockSize
        self.rows = rows
        self.cols = cols
    }

    class func gridTexture(blockSize:CGFloat, rows:Int, cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return SKTexture(image: image!)
    }

    func gridPosition(row:Int, col:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(cols)) / 2.0 + offset
        let y = CGFloat(rows - row - 1) * blockSize - (blockSize * CGFloat(rows)) / 2.0 + offset
        return CGPoint(x:x, y:y)
    }
    
    func moveElement(scene: GameScene) {
        //
    }
    
    func addElement(scene: GameScene) {
        //
    }
    
    func removeElement(scene: GameScene) {
        //
    }
    
    func computeScore(scene: GameScene) {
        
    }
}
