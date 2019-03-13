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
    
    override func didMove(to view: SKView) {
        self.nodes = self.genNodes(20000, radius: 300)
        self.environment = BirdsField(nodes: self.nodes, partsx: 100, partsy: 100)
        
        self.nodes.forEach { agent in
            let queue = DispatchQueue(label: String(agent.id))
            queue.async {
                agent.runAction(environment: self.environment!)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
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
            
            let act = SKAction.moveBy(x: CGFloat(x), y: CGFloat(y), duration: 3)
            let reversed = act.reversed()
            let group = SKAction.sequence([act, reversed])
            let r = SKAction.repeatForever(group)

//            node.run(r)
            self.addChild(node)
            
            
            // Swarm Agent implementation
            let agent = SwarmAgent(category: 1, id: i, relatedNode: node, actions: [act]) { (act, env) in
                return 1
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
