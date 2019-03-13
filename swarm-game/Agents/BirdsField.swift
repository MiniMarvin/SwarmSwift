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
    
    override init(partsx: Int, partsy: Int, canvasWidth:Int, canvasHeight:Int) {
        self.nodes = []
        super.init(partsx: partsx, partsy: partsy, canvasWidth: canvasWidth, canvasHeight: canvasHeight)
    }
    
    init(nodes:[SwarmAgent], partsx: Int, partsy: Int) {
        self.nodes = nodes
        
        // Copy every single node reference to the map to make it properly iterable
        for node in self.nodes {
            self.nodeMap[node.id] = node
        }
        super.init(partsx: partsx, partsy: partsy)
        
        // Setup the force field
        self.nodes.forEach { (node) in
            self.setupStatus(node: node)
        }
    }
    
    func addAgent(node:SwarmAgent) {
        self.nodes.append(node)
    }
    
    func updateStatus(node:SwarmAgent) {
        let x:Double = node.point.x
        let y:Double = node.point.x
        let x1:Double = Double(node.relatedNode!.position.x)
        let y1:Double = Double(node.relatedNode!.position.y)
        let w:Double = Double(self.canvas!.0)
        let h:Double = Double(self.canvas!.0)
        
        let v = self.valueAtPosition(x: x, y: y, w: w, h: h)
        let v1 = self.valueAtPosition(x: x1, y: y1, w: w, h: h)
        
        self.setPosition(x: x, y: y, w: w, h: h, value: v - 1)
        self.setPosition(x: x1, y: y1, w: w, h: h, value: v1 + 1)
    }
    
    
    private func setupStatus(node:SwarmAgent) {
        let x:Double = node.point.x
        let y:Double = node.point.x
        let w:Double = Double(self.canvas!.0)
        let h:Double = Double(self.canvas!.0)
        
        let value = self.valueAtPosition(x: x, y: y, w: w, h: h)
        self.setPosition(x: x, y: y, w: w, h: h, value: value + 1)
    }
    
}
