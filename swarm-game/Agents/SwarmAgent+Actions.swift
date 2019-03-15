//
//  SwarmAgent+Actions.swift
//  swarm-game
//
//  Created by Caio Gomes on 14/03/19.
//  Copyright © 2019 Caio Gomes. All rights reserved.
//

import Foundation
import SpriteKit


// MARK: - Extension to the actions of the agent based in every single environment
extension SwarmAgent {
    func runAction(environment:BirdsField, completion: @escaping () -> Void = {}) -> Bool {
        let act = self.selectAction(environment: environment)
        guard let _ = self.relatedNode else {return false}
        
        self.relatedNode?.run(act, completion: {
            environment.updateStatus(node: self)
            self.point = SwarmPoint((self.relatedNode?.position) ?? CGPoint(x: 0, y: 0))
            // completion handler, may be used to create an infinity loop
            completion()
        })
        
        return true
    }
}
