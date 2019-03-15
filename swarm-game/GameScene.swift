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
    
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    private var environment: BirdsField?
    private var nodes: [SwarmAgent] = []
    
    private var tm:TimeInterval = 0
    
    override func didMove(to view: SKView) {
        self.nodes = self.genNodes(10000, radius: 300)
        self.environment = BirdsField(nodes: self.nodes, partsx: 10, partsy: 10, canvasWidth: Double(self.frame.width), canvasHeight: Double(self.frame.height))
        
        self.nodes.forEach { agent in
            agent.startOperation(environment: self.environment!)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if currentTime - self.tm > 3 {
            self.tm = currentTime
        }
    }
    
    func genNodes(_ n:Int, radius:Int = 100, circleRadius:Int = 2) -> [SwarmAgent] {
        
        var nodes:[SwarmAgent] = []
        
        for i in 1...n {
            let node = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 4, height: 4))
            node.name = String(i)
            
            let limit:Double = Double(radius)
            var x = randomInterval(min: 0, max: limit, precision: 5)
            var y = sqrt(limit*limit - x*x)
            
            if arc4random()%2 == 0 {
                x *= -1
            }
            if arc4random()%2 == 0 {
                y *= -1
            }
            
            let act = SKAction.moveBy(x: CGFloat(x), y: CGFloat(y), duration: 0.5)
            let reversed = act.reversed()
//            let group = SKAction.sequence([act, reversed])
//            let r = SKAction.repeatForever(group)
            let rotate = SKAction.rotate(byAngle: 0.1, duration: 0.5)
            
//            node.run(r)
            self.addChild(node)
            
            
            // Swarm Agent implementation
            let agent = SwarmAgent(category: 1, id: i, relatedNode: node, actions: [act, reversed]) { (act, env, agent) in
                let x = Double((agent.relatedNode?.position.x)!)
                let y = Double((agent.relatedNode?.position.y)!)
                var val = 0.0
                if env.valueAtPosition(x: x, y: y) > 50 {
                    if (act == reversed) {
                        val = -100
                    }
                    else {
                        val = 100
                    }
                }
                else {
                    if (act == reversed) {
                        val = 100
                    }
                    else {
                        val = -100
                    }
                }
                
                return val
            }
            nodes.append(agent)
        }
        
        return nodes
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
