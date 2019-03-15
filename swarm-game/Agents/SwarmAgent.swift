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
    // is the only need to the comparisons works properly, yet, self
    // must allways be passed as argument to the node compute it properly
    // knowing it's state and everything else. In this architecture
    // there's a sense of "self", "environment", "actual action"
    var scoreFunction:(SKAction, SwarmEnvironment, SwarmAgent) -> Double
    var relatedNode:SKNode? = nil
    var point:SwarmPoint = SwarmPoint(x: 0, y:  0)
    var id:Int
    
    private var isOperating:Bool = false
    private var operationQueue:DispatchQueue = DispatchQueue(label: "operating queue")
    private var task:DispatchWorkItem
    
    /// Init the agent with the necessary features
    ///
    /// - Parameters:
    ///   - category: The category of the node
    ///   - actions: The action that the node must perform
    ///   - scoreFunction: The score function to be computed based in the environment
    init(category:Int, id:Int, relatedNode:SKSpriteNode, actions:[SKAction], scoreFunction:@escaping (SKAction, SwarmEnvironment, SwarmAgent) -> Double = {(_,_,_) in return 1}) {
        self.allowedActions = actions
        self.category = category
        self.scoreFunction = scoreFunction
        self.id = id
        self.relatedNode = relatedNode
        self.point = SwarmPoint(relatedNode.position)
        
        // task
        self.task = DispatchWorkItem(block: {})
        
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
    func selectAction<T:SwarmEnvironment>(environment:T) -> SKAction {
        let scores = self.allowedActions.map({action in
            (self.scoreFunction(action, environment, self), action)
        })
        
        let tmp:SKAction? = self.allowedActions[0]
        let act:(Double, SKAction?) = scores.reduce((0, tmp)) { (res, el) in
            if res.0 < el.0 {
                return (el.0, el.1)
            }
            return res
        }
        
        return act.1!
    }
    
    func runAction(environment:SwarmEnvironment, completion: @escaping () -> Void = {}) -> Bool {
        let act = self.selectAction(environment: environment)
        guard let _ = self.relatedNode else {return false}
        
        self.relatedNode?.run(act, completion: {
            self.point = SwarmPoint((self.relatedNode?.position) ?? CGPoint(x: 0, y: 0))
            // completion handler, may be used to create an infinity loop
            completion()
        })
        
        return true
    }
    
    
    /// Keep the agent running the actions as long as it is operating recursively
    ///
    /// - Parameter environment: The environment where the system is allocated
    func runActionWhileOperating(environment:SwarmEnvironment) {
        let act = self.selectAction(environment: environment)
        guard let _ = self.relatedNode else {return}
        
        
        if (relatedNode?.hasActions())! {
            if self.isOperating {
                let item = DispatchWorkItem(block: {
                    self.runActionWhileOperating(environment: environment)
                })
                self.operationQueue.async(execute: item)
            }
            return
        }
        
        self.relatedNode?.run(act, completion: {
            self.point = SwarmPoint((self.relatedNode?.position) ?? CGPoint(x: 0, y: 0))
            if self.isOperating {
                let item = DispatchWorkItem(block: {
                    self.runActionWhileOperating(environment: environment)
                })
                self.operationQueue.async(execute: item)
            }
        })
    }
    
    
    
    /// Startup the agent automatic operation
    ///
    /// - Parameter environment: The environment to the system to use
    func startOperation(environment:SwarmEnvironment) {
        if self.isOperating {
            return
        }
        
        self.isOperating = true
        self.operationQueue.async {
            self.runActionWhileOperating(environment: environment)
        }
    }
    
    
    /// Finish the operation of the agent
    func finishOperation() {
        self.isOperating = false
//        self.task.cancel()
    }
}
