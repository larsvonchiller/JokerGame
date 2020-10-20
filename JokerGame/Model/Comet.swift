//
//  Comet.swift
//  JokerGame
//
//  Created by Andrey Matoshko on 9/27/20.
//  Copyright © 2020 Andrey Matoshko. All rights reserved.
//

import Foundation
import SpriteKit

struct Comet {
    
    private weak var node: SKSpriteNode?
    
    private var currentFieldCell: GameFieldCell?
    private var previousFieldCell: GameFieldCell?
    
    /// Updates Comet position to the given coordinates
    /// - Parameters:
    ///   - row: Row of the GameFieldCell
    ///   - column: Column of the GameFieldCell
    ///   - complition: Returns previous Cell coordinates for handling
    mutating func updatePosition(row: Int, column: Int, complition: (((row: Int, column: Int)) -> Void)) {
        
        let newCell = GameFieldCell(row: row, column: column, state: .current)
        guard currentFieldCell != newCell else { return }
            
        previousFieldCell = currentFieldCell
        currentFieldCell = newCell
        
        if let previousCell = previousFieldCell { complition((row: previousCell.row, column: previousCell.column)) }
    }
    
    init(with cometNode: SKSpriteNode) {
        node = cometNode
    }
    
}


