//
//  GameCoordinator.swift
//  JokerGame
//
//  Created by Andrey Matoshko on 9/27/20.
//  Copyright © 2020 Andrey Matoshko. All rights reserved.
//

import Foundation

struct GameCoordinator {
    
    //MARK: - Properties
    
    private var map: Map!
    private var comet: Comet!
    
    //MARK: - Public API
        
    /// Adds given Map to the game
    /// - Parameter map: Map instance for current game
    mutating func addMap(_ map: Map) {
        self.map = map
    }
    
    /// Adds given Comet to the game
    /// - Parameter comet: Comet instance for current game
    mutating func addComet(_ comet: Comet) {
        self.comet = comet
    }
    
    /// Returns Comet initial coordinates
    /// - Returns: Tuple of initilal coordinates
    func getCometInitialCoordinates() -> (row: Int, column: Int) { map.getInitialCellCoordinats() }
    
    /// Checks and returns GameFieldStatus
    /// - Parameters:
    ///   - row: Row of a given cell
    ///   - column: Column of a given cell
    /// - Returns: Returns boolean flag is GameFieldCell with given coordinates enabled
    func isGameFieldEnabled(row: Int, column: Int) -> Bool { map.isEnabledFor(row: row, column: column) }
    
    /// Is player won
    /// - Returns: Is game finished flag
    func isGameFinished() -> Bool { map.isGameFinished() }
    
    /// Sets the current GameField position
    /// - Parameters:
    ///   - rowIndex: Row index of the cell
    ///   - columnIndex: Column index of the cell
    mutating func updateCometPosition(row: Int, column: Int) {
        self.map.setState(.current, row: row, column: column)
        
        self.comet.updatePosition(row: row, column: column) { previousCellCoordinates in
            self.map.setState(.inActive, row: previousCellCoordinates.row, column: previousCellCoordinates.column)
        }
    }
}
