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
    var cellSize:CGFloat!
    var elementSize:CGFloat!
    let viewLeftBoundary = CGFloat(35.0)
    let viewBottomBoundary = CGFloat(300.0)
    
    
    convenience init?(cellSize:CGFloat, elementSize:CGFloat, rows:Int, cols:Int) {
        guard let texture = Grid.gridTexture(cellSize: cellSize, elementSize: elementSize, rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.black, size: texture.size())
        self.cellSize = cellSize
        self.elementSize = elementSize
        self.rows = rows
        self.cols = cols
    }
    
    
    class func gridTexture(cellSize:CGFloat, elementSize:CGFloat, rows:Int, cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*cellSize, height: CGFloat(rows)*cellSize)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        // set fill color
        context.setFillColor(UIColor.black.cgColor)
            
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return SKTexture(image: image!)
    }
    
    
    func getNumberOfLabels(level: Int) -> Int {
        switch level {
        case 1...5:
            return 4
        case 6...10:
            return 5
        default:
            return 6
        }
    }
    
    
    func getDifficulty(level: Int) -> Double {
        switch level {
        case 1...5:
            return 0.6
        case 6...10:
            return 0.7
        default:
            return 0.8
        }
    }
    
    
    func gridPosition(row:Int, col:Int) -> CGPoint {
        //let ffset = cellSize / 2.0 + 0.5
        //let x = CGFloat(150) + CGFloat(col) * cellSize - (cellSize * CGFloat(cols)) / 2.0 + offset
        //let y = CGFloat(500) + CGFloat(rows - row - 1) * cellSize - (cellSize * CGFloat(rows)) / 2.0 + offset
        
        let centerOffset = cellSize / 2.0
        let x = viewLeftBoundary + CGFloat(col - 1) * cellSize + centerOffset
        let y = viewBottomBoundary + CGFloat(row - 1) * cellSize + centerOffset
        return CGPoint(x:x, y:y)
    }
    
    
    func fillGrid(level: Int, scene: GameScene) {
        let nLabels:Int = getNumberOfLabels(level: level)
        let difficulty: Double = getDifficulty(level: level)
        for r in 1...rows {
            for c in 1...cols {
                let node = readElement(row: r, col: c, scene: scene)
                if node==nil{
                    createElement(row:r, col:c, nLabels:nLabels, difficulty: difficulty, scene: scene)
                }
            }
        }
    }
    
    
    func playRound(node: SKNode, level: Int, scene: GameScene) -> (Int, Int, Bool, Bool) {
        // combo, score, RoundOver, GameOver
        let (label, row, col) = nodeNameToLabelRowCol(s: node.name!)

        let connectedElements = findConnectedElements(label: label, row: row, col: col, scene: scene, connectedElements: [])
        let combo: Int = connectedElements.count
        
        if combo < 3 {
            return (0, 0, false, false)
        }
        // removeElements
        connectedElements.forEach({ deleteElement(element: $0) })
        
        
        // moveElements
        updateGrid(scene: scene)
        let score: Int = getScore(combo: combo, level: level)
        
        // checkAnyMovesLeft
        if isRoundOver(scene: scene) {
            fillGrid(level: level, scene: scene)
            SKAction.wait(forDuration: 1.0)
        } else {
            return (combo, score, false, false)
        }
        
        if isRoundOver(scene: scene) {
            return (combo, score, true, true)
        }

        return (combo, score, true, false)
        
    }
    
    func isRoundOver(scene: GameScene) -> Bool {
        for r in 1...rows {
            for c in 1...cols {
                let node = readElement(row: r, col: c, scene: scene)
                
                if node==nil {
                    continue
                }
                
                let (nodeLabel, _, _) = nodeNameToLabelRowCol(s: node!.name!)
                let connectedElements = findConnectedElements(label: nodeLabel, row: r, col: c, scene: scene, connectedElements: [])
                if connectedElements.count > 2 {
                    return false
                }
            }
        }
        
        return true
    }
    
    func findConnectedElements(label: Int, row: Int, col: Int, scene: GameScene, connectedElements: [SKNode]) -> [SKNode] {
        var connectedElements = connectedElements
        
        let node = readElement(row: row, col: col, scene: scene)
        if node==nil {
            return connectedElements
        }
        
        if connectedElements.map({ $0.name }).contains(node!.name) {
            return connectedElements
        }
        
        let (nodeLabel, _, _) = nodeNameToLabelRowCol(s: node!.name!)
        if nodeLabel==label {
            connectedElements.append(node!)
            connectedElements = findConnectedElements(label: label, row: row-1, col: col, scene: scene, connectedElements: connectedElements)
            connectedElements = findConnectedElements(label: label, row: row+1, col: col, scene: scene, connectedElements: connectedElements)
            connectedElements = findConnectedElements(label: label, row: row, col: col-1, scene: scene, connectedElements: connectedElements)
            connectedElements = findConnectedElements(label: label, row: row, col: col+1, scene: scene, connectedElements: connectedElements)
        }
        
        return connectedElements
    }
    
    
    func createElement(row:Int, col:Int, nLabels:Int, difficulty: Double, scene: GameScene) {
        let pos = gridPosition(row: row, col: col)
        let size = CGSize(width: elementSize, height: elementSize)
        let element = Element(row: row, col:col, nLabels: nLabels, difficulty: difficulty)
        let node: SKNode = element.getSKSpriteNode(pos: pos, size: size)
        scene.addChild(node)
    }
    
    
    func updateGrid(scene: GameScene) {
        SKAction.wait(forDuration: 0.5)
        for c in 1...cols {
            updateColumn(col: c, scene: scene)
        }
    }
    
    
    func updateColumn(col: Int, scene: GameScene) {
        var nodes: [SKNode] = []
        for r in 1...rows {
            let node = readElement(row: r, col: col, scene: scene)
            if node==nil {
                continue
            }
            nodes.append(node!)
        }
        
        for (idx,node) in nodes.enumerated() {
            updateElement(node: node, row: idx+1, col: col, scene: scene)
        }
    }
    
    
    
    func updateElement(node: SKNode, row:Int, col:Int, scene: GameScene)  {
        let (label, _, _) = nodeNameToLabelRowCol(s: node.name!)
        
        let (x, y) = locationDelta(
            left: CGPoint(x: node.position.x, y: node.position.y),
            right: gridPosition(row: row, col: col)
        )
        
        let move = SKAction.moveBy(x: x, y: -y, duration: 0.2)
        node.run(move)
        node.name = "element[\(label),\(row),\(col)]"
    }
    
    func locationDelta(left: CGPoint, right: CGPoint) -> (CGFloat, CGFloat) {
        return (left.x - right.x, left.y - right.y)
    }
    
    
    func deleteElement(element: SKNode) {
        element.removeFromParent()
    }
    
    
    func readElement(row: Int, col:Int, scene:GameScene) -> SKNode? {
        let pos = gridPosition(row: row, col: col)
        let node : SKNode = scene.atPoint(pos)
        let name =  node.name ?? ""
        
        if name.starts(with: "element") {
            return node
        }
        return nil
    }
    
    
    func nodeNameToLabelRowCol(s: String) -> (Int, Int, Int) {
        let matched = s.regexFindAll(for: "[0-9]+", in: s).map { Int($0) ?? -1 }
        return (matched[0], matched[1], matched[2])
    }
    
    
    func getScore(combo: Int, level: Int) -> Int {
        return Int( Double(combo) * (Double(combo) - 1.0) * ( log( Double(level) ) + 1.0) / 2.0 )
    }
}
