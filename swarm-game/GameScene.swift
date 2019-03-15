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
        // Add physics body to border
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.pinned = true
        self.physicsBody?.collisionBitMask = 0b01
        
//        self.createFields()
        
        self.nodes = self.genNodes(1000, radius: 300, circleRadius: 4)
        self.environment = BirdsField(nodes: self.nodes, partsx: 30, partsy: 120, canvasWidth: Double(self.frame.width), canvasHeight: Double(self.frame.height))
        
        self.nodes.forEach { agent in
            agent.relatedNode?.run(SKAction.applyImpulse(CGVector(dx: 10, dy: 0), duration: 1))
//            agent.startOperation(environment: self.environment!)
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
            let node = SKSpriteNode(color: SKColor.blue, size: CGSize(width: circleRadius, height: circleRadius))
            node.name = String(i)
//            node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: circleRadius, height: circleRadius))
            node.physicsBody = SKPhysicsBody(edgeLoopFrom: node.frame)
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.allowsRotation = true
//            node.physicsBody?.restitution = 1
            node.physicsBody?.fieldBitMask = 0b01
            node.physicsBody?.collisionBitMask = 0b01
            
            let w = Double(-self.frame.width/2) + self.randomInterval(min: 0, max: Double(self.frame.width), precision: 3)
            let h = Double(-self.frame.height/2) + self.randomInterval(min: 0, max: Double(self.frame.height), precision: 3)
            node.position = CGPoint(x: w, y: h)
            

            
            let limit:Double = Double(radius)
            var x = randomInterval(min: 0, max: limit, precision: 5)
            var y = sqrt(limit*limit - x*x)
            
            if arc4random()%2 == 0 {
                x *= -1
            }
            if arc4random()%2 == 0 {
                y *= -1
            }
            
            let dur = self.randomInterval(min: 0, max: 1, precision: 3)
//            let act = SKAction.moveBy(x: CGFloat(x), y: CGFloat(y), duration: dur)
//            let reversed = act.reversed()
//            let action = SKAction.applyImpulse(CGVector(dx: x/100, dy: y/100), duration: dur)
//            let reversed = SKAction.applyImpulse(CGVector(dx: -x/100, dy: -y/100), duration: dur)
            let action = SKAction.speed(to: 0, duration: dur)
            let reversed = SKAction.speed(to: -100, duration: dur)
            let rotate = SKAction.rotate(byAngle: 10, duration: 0.5)
            
            self.addChild(node)
            
            // Swarm Agent implementation
            let agent = SwarmAgent(category: 1, id: i, relatedNode: node, actions: [action, rotate]) { (act, env, agent) in
                let x = Double((agent.relatedNode?.position.x)!)
                let y = Double((agent.relatedNode?.position.y)!)
                var val = 0.0
                
                if env.valueAtPosition(x: x, y: y) > Double(n)/100 {
                    if (act == rotate) { val = -100 }
                    else { val = 100 }
                }
                else {
                    if (act == rotate) { val = 100 }
                    else { val = -100 }
                }
                
                return val
            }
            nodes.append(agent)
        }
        
        return nodes
    }
    
    func createFields() {
        let field = SKFieldNode.vortexField()
        field.position = CGPoint(x: 0, y: 0)
        field.strength = 0.2
        field.categoryBitMask = 0b01
        
//        let field1 = SKFieldNode.vortexField()
//        field1.position = CGPoint(x: 0, y: 100)
//        field1.strength = 2
//        field1.categoryBitMask = 0b01
        
        self.addChild(field)
//        self.addChild(field1)
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
