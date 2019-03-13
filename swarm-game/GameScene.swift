//
//  GameScene.swift
//  swarm-game
//
//  Created by Caio Gomes on 11/03/19.
//  Copyright © 2019 Caio Gomes. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.genNodes(20000, radius: 300)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func genNodes(_ n:Int, radius:Int = 100, circleRadius:Int = 2) {
        for i in 1...n {
//            let node = SKShapeNode(circleOfRadius: CGFloat(circleRadius))
            let node = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 4, height: 4))
//            let emmitter = SKEmitterNode(fileNamed: "Blue")
//            node.addChild(emmitter!)
            
            let limit:Double = Double(radius)
            var x = randomInterval(min: 0, max: limit, precision: 5)
            var y = sqrt(limit*limit - x*x)
            
            if arc4random()%2 == 0 {
                x *= -1
            }
            if arc4random()%2 == 0 {
                y *= -1
            }
            
            let act = SKAction.moveBy(x: CGFloat(x), y: CGFloat(y), duration: 1)
            let reversed = act.reversed()
            let group = SKAction.sequence([act, reversed])
            let r = SKAction.repeatForever(group)
            
            node.run(r)
            self.addChild(node)
        }
    }
    
    func randomInterval(min:Double, max:Double, precision:Int) -> Double {
        var m:Int = 1
        for _ in 1...precision {
            m *= 10
        }
        let r = (max - min)*Double(arc4random()%(UInt32(m) + UInt32(1)))/Double(m)
        return r
    }
}
