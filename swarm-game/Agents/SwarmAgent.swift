//
//  SwarmAgent.swift
//  swarm-game
//
//  Created by Caio Gomes on 12/03/19.
//  Copyright © 2019 Caio Gomes. All rights reserved.
//

import Foundation
import SpriteKit

class SwarmAgent: NSObject {
    
    var category:Int
    var allowedActions:[SKAction]
    var scoreFunction:(SKAction, SwarmEnvironment) -> Double
    
    
    /// Init the agent with the necessary features
    ///
    /// - Parameters:
    ///   - category: The category of the node
    ///   - actions: The action that the node must perform
    ///   - scoreFunction: The score function to be computed based in the environment
    init(category:Int, actions:[SKAction], scoreFunction:@escaping (SKAction, SwarmEnvironment) -> Double) {
        self.allowedActions = actions
        self.category = category
        self.scoreFunction = scoreFunction
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
    func selectAction(environment:SwarmEnvironment) -> SKAction {
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
}
