//
//  BirdsField.swift
//  swarm-game
//
//  Created by Caio Gomes on 12/03/19.
//  Copyright © 2019 Caio Gomes. All rights reserved.
//

import Foundation
import SpriteKit

class BirdsField:SwarmEnvironment {
    var nodes:[SwarmAgent]
    var nodeMap:[Int:SwarmAgent] = [:]
    
    override init(partsx: Int, partsy: Int, canvasWidth:Double, canvasHeight:Double) {
        self.nodes = []
        super.init(partsx: partsx, partsy: partsy, canvasWidth: canvasWidth, canvasHeight: canvasHeight)
    }
    
    init(nodes:[SwarmAgent], partsx: Int, partsy: Int, canvasWidth:Double, canvasHeight:Double) {
        self.nodes = nodes
        
        // Copy every single node reference to the map to make it properly iterable
        for node in self.nodes {
            self.nodeMap[node.id] = node
        }
        super.init(partsx: partsx, partsy: partsy, canvasWidth:canvasWidth, canvasHeight:canvasHeight)
        
        // Setup the force field
        self.nodes.forEach { (node) in
            self.setupStatus(node: node)
        }
    }
    
    
    /// Insert an agent to the environment
    ///
    /// - Parameter node: The agent to be insert
    func addAgent(node:SwarmAgent) {
        self.nodes.append(node)
    }
    
    
    
    /// Tells that the status of the agent has been updated
    ///
    /// - Parameter node: The agent that changed it's status
    func updateStatus(node:SwarmAgent) {
        let x:Double = node.point.x
        let y:Double = node.point.x
        let x1:Double = Double(node.relatedNode!.position.x)
        let y1:Double = Double(node.relatedNode!.position.y)
        
        let v = self.valueAtPosition(x: x, y: y)
        let v1 = self.valueAtPosition(x: x1, y: y1)
        
        self.setPosition(x: x, y: y, value: v - 1)
        self.setPosition(x: x1, y: y1, value: v1 + 1)
    }
    
    
    /// Setup a new agent in the environment
    ///
    /// - Parameter node: The agent that have been inserted
    private func setupStatus(node:SwarmAgent) {
        let x:Double = node.point.x
        let y:Double = node.point.x
        
        let value = self.valueAtPosition(x: x, y: y)
        self.setPosition(x: x, y: y, value: value + 1)
    }
    
}
