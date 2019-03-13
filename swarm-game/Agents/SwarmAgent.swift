//
//  SwarmAgent.swift
//  swarm-game
//
//  Created by Caio Gomes on 12/03/19.
//  Copyright © 2019 Caio Gomes. All rights reserved.
//

import Foundation
import SpriteKit

struct SwarmPoint {
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    init(_ point:CGPoint) {
        self.x = Double(point.x)
        self.y = Double(point.y)
    }
}

class SwarmAgent: NSObject {
    
    var category:Int
    var allowedActions:[SKAction]
    // SwarmEnvironment works without being generic because the
    // SwarmEnvironment contains the forcefield and the forcefield
    // is the only need to the comparisons works properly
    var scoreFunction:(SKAction, SwarmEnvironment) -> Double
    var relatedNode:SKNode? = nil
    var point:SwarmPoint = SwarmPoint(x: 0, y:  0)
    var id:Int
    
    
    /// Init the agent with the necessary features
    ///
    /// - Parameters:
    ///   - category: The category of the node
    ///   - actions: The action that the node must perform
    ///   - scoreFunction: The score function to be computed based in the environment
    init(category:Int, id:Int, relatedNode:SKSpriteNode, actions:[SKAction], scoreFunction:@escaping (SKAction, SwarmEnvironment) -> Double) {
        self.allowedActions = actions
        self.category = category
        self.scoreFunction = scoreFunction
        self.id = id
        self.relatedNode = relatedNode
        self.point = SwarmPoint(relatedNode.position)
        super.init()
    }
    
    
    /// Add a new action to the availeable actions array to the agent
    ///
    /// - Parameter action:
    func addAction(action:SKAction) {
        self.allowedActions.append(action)
    }
    

    /// Select an action to perform into the node
    ///
    /// - Parameter environment: The environment that the node may look at
    /// - Returns: The selected action to be performed into the node
    private func selectAction<T:SwarmEnvironment>(environment:T) -> SKAction {
        let scores = self.allowedActions.map({action in
            (self.scoreFunction(action, environment), action)
        })
        
        let act:(Double, SKAction?) = scores.reduce((0, nil)) { (res, el) in
            if res.0 < el.0 {
                return (el.0, el.1)
            }
            return res
        }
        
        return act.1!
    }
    
    func runAction<T:SwarmEnvironment>(environment:T, completion: @escaping () -> Void = {}) -> Bool {
        let act = self.selectAction(environment: environment)
        guard let _ = self.relatedNode else {return false}

        if environment is BirdsField {
            
            print(act)
            
            let env = environment as! BirdsField
            self.relatedNode?.run(act, completion: {
                env.updateStatus(node: self)
                self.point = SwarmPoint((self.relatedNode?.position) ?? CGPoint(x: 0, y: 0))
                
                // completion handler, may be used to create an infinity loop
                completion()
            })
        }
        
        return true
    }
}
