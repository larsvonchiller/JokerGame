//
//  GameFieldCell.swift
//  JokerGame
//
//  Created by Andrey Matoshko on 9/27/20.
//  Copyright © 2020 Andrey Matoshko. All rights reserved.
//

import Foundation

struct GameFieldCell {
    
    //MARK: - Properties
    
    let row: Int
    let column: Int
    
    let isInitial: Bool
    
    private var state: FieldCellState
    
    //MARK: - Public API
    
    var currentState: FieldCellState { state }
    
    var isEnabled: Bool { state == .active }
    
    mutating func activate() { state = .current }
    
    mutating func deactivate() { state = .inActive }
    
    mutating func enable() { state = .active }
    
    mutating func disable() { state = .none }

    //MARK: - Init
    
    init(row: Int, column: Int, state: FieldCellState = .none, isInitial: Bool = false ) {
        self.row = row
        self.column = column
        self.state = state
        self.isInitial = isInitial
    }
}

//MARK: - GameFieldCell + Equatable

extension GameFieldCell: Equatable {
    
    static func == (lhs: GameFieldCell, rhs: GameFieldCell) -> Bool {
        guard lhs.row == rhs.row && lhs.column == rhs.column else { return false }
        return true
    }
}
