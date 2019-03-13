//
//  SwarmEnvironment.swift
//  swarm-game
//
//  Created by Caio Gomes on 12/03/19.
//  Copyright © 2019 Caio Gomes. All rights reserved.
//

import Foundation

class SwarmEnvironment:NSObject {
    
    var partsx:Int
    var partsy:Int
    var forceField:[[Double]]
    
    /// Build a clean forcefiend
    ///
    /// - Parameter parts: The number of parts in which the forcefield will be splitten
    init(parts:Int) {
        self.partsx = parts
        self.partsy = parts
        // Build homogeneous forcefield
        self.forceField = Array(repeating: Array(repeating: 0, count: parts), count: parts)
        super.init()
    }
    
    /// Build a clean forcefiend
    ///
    /// - Parameter parts: The number of parts in which the forcefield will be splitten
    init(partsx:Int, partsy:Int) {
        self.partsx = partsx
        self.partsy = partsy
        // Build homogeneous forcefield
        self.forceField = Array(repeating: Array(repeating: 0, count: partsy), count: partsx)
        super.init()
    }
    
    
    /// Set a value to the specific forcefield point
    ///
    /// - Parameters:
    ///   - x: The x part in the board
    ///   - y: The y part in the board
    ///   - value: The numeric value of the forcefield in the defined spot
    func setPart(x:Int, y:Int, value:Double) {
        self.forceField[x][y] = value
    }
    
    
    /// Set a value to a specific forcefield point computed from the sprite computed size
    ///
    /// - Parameters:
    ///   - x: The x in the sprite
    ///   - y: The y in the sprite
    ///   - w: The width of the canvas
    ///   - h: The height of the canvas
    ///   - value: The numeric value of the forcefield in the defined spot
    func setPosition(x:Double, y:Double, w:Double, h:Double, value:Double) {
        let px = Int(Double(self.partsx)*x/w)
        let py = Int(Double(self.partsy)*y/h)
        
        self.forceField[px][py] = value
    }
    
    
    /// Get the value of the forcefield in a specific part
    ///
    /// - Parameters:
    ///   - x: The x positioning
    ///   - y: The y positioning
    /// - Returns: The numeric value of the force field in this position
    func valueAtPart(x:Int, y:Int) -> Double {
        return self.forceField[x][y]
    }
    
    
    /// Get the value from a point computed from the sprite computed size
    ///
    /// - Parameters:
    ///   - x: The x value from the canvas
    ///   - y: The y value from the canvas
    ///   - w: The width of the canvas
    ///   - h: The height of the canvas
    /// - Returns: The numeric value of the forcefield in the specific point
    func valueAtPosition(x:Double, y:Double, w:Double, h:Double) -> Double {
        let px = Int(Double(self.partsx)*x/w)
        let py = Int(Double(self.partsy)*y/h)
        
        return self.forceField[px][py]
    }
}