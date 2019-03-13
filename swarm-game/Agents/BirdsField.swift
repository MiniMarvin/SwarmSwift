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
    var nodes:[SKSpriteNode]
    
    override init(partsx: Int, partsy: Int) {
        self.nodes = []
        super.init(partsx: partsx, partsy: partsy)
    }
    
    init(nodes:[SKSpriteNode], partsx: Int, partsy: Int) {
        self.nodes = nodes
        super.init(partsx: partsx, partsy: partsy)
    }
    
    func addAgent(node:SKSpriteNode) {
        self.nodes.append(node)
//        node.position
    }
    
    
    
}
