//
//  SwarmEnvironment.swift
//  swarm-game
//
//  Created by Caio Gomes on 12/03/19.
//  Copyright © 2019 Caio Gomes. All rights reserved.
//

import Foundation

class SwarmEnvironment:NSObject {
    
    // MARK: Variables
    var canvas:(Double, Double)
    var partsx:Int
    var partsy:Int
    var forceField:[[Double]]
    
    
    // MARK: Inits
    
    
    /// Build a clean forcefiend
    ///
    /// - Parameters:
    ///   - parts: The number of parts in which the forcefield will be splitten
    ///   - canvasWidth: Width of the canvas in wich the field is set
    ///   - canvasHeight: Height of the canvas in which the field is set
    init(parts:Int, canvasWidth:Double, canvasHeight:Double) {
        self.partsx = parts
        self.partsy = parts
        self.canvas = (canvasWidth, canvasHeight)
        
        // Build homogeneous forcefield
        self.forceField = Array(repeating: Array(repeating: 0, count: parts), count: parts)
        super.init()
    }
    
    
    /// Build a clean forcefiend
    ///
    /// - Parameters:
    ///   - partsx: Number of parts in the x axis
    ///   - partsy: Number of parts in the y axis
    ///   - canvasWidth: Width of the canvas in wich the field is set
    ///   - canvasHeight: Height of the canvas in which the field is set
    init(partsx:Int, partsy:Int, canvasWidth:Double, canvasHeight:Double) {
        self.partsx = partsx
        self.partsy = partsy
        self.canvas = (canvasWidth, canvasHeight)
        
        // Build homogeneous forcefield
        self.forceField = Array(repeating: Array(repeating: 0, count: partsy), count: partsx)
        super.init()
    }
    
    // MARK: Builders + Setters
    
    
    /// Setup the size of the canvas where the field is set
    ///
    /// - Parameters:
    ///   - canvasWidth: Width of the canvas in wich the field is set
    ///   - canvasHeight: Height of the canvas in which the field is set
    func setCanvas(canvasWidth:Double, canvasHeight:Double) {
        self.canvas = (canvasWidth, canvasHeight)
    }
    
    
    /// Set a value to the specific forcefield point
    ///
    /// - Parameters:
    ///   - x: The x part in the board
    ///   - y: The y part in the board
    ///   - value: The numeric value of the forcefield in the defined spot
    func setPart(x:Int, y:Int, value:Double) {
        let w = self.partsx
        let h = self.partsy
        if x >= Int(w) || x < 0 || y >= Int(h) || y < 0 {
            return
        }
        
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
    func setPosition(x:Double, y:Double, value:Double) {
        let w = self.canvas.0
        let h = self.canvas.1
        let xc = x + w/2
        let yc = y + h/2
        let px = Int(Double(self.partsx)*xc/w)
        let py = Int(Double(self.partsy)*yc/h)
        
        if px >= Int(self.partsx) || px < 0 || py >= Int(self.partsy) || py < 0 {
            return
        }
        self.forceField[px][py] = value
    }
    
    
    // MARK: Getters
    
    
    /// Get the value of the forcefield in a specific part
    ///
    /// - Parameters:
    ///   - x: The x positioning
    ///   - y: The y positioning
    /// - Returns: The numeric value of the force field in this position
    func valueAtPart(x:Int, y:Int) -> Double {
        let w = self.partsx
        let h = self.partsy
        if x >= Int(w) || x < 0 || y >= Int(h) || y < 0 {
            return 0
        }
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
    func valueAtPosition(x:Double, y:Double) -> Double {
        let w = self.canvas.0
        let h = self.canvas.1
        let xc = x + w/2
        let yc = y + h/2
        let px = Int(Double(self.partsx)*xc/w)
        let py = Int(Double(self.partsy)*yc/h)
        
        if px >= Int(self.partsx) || px < 0 || py >= Int(self.partsy) || py < 0 {
            return 0
        }
        return self.forceField[px][py]
    }
    
}
