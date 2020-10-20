//
//  Map.swift
//  JokerGame
//
//  Created by Andrey Matoshko on 9/27/20.
//  Copyright © 2020 Andrey Matoshko. All rights reserved.
//

import Foundation
import SpriteKit

struct Map {
    
    //MARK: - Properties
    
    private var node: SKTileMapNode?
    
    private var fieldCells = [GameFieldCell]()
    
    private let rows: Int
    private let columns: Int
    
    private var activeFieldsNumber: Int
    
    //MARK: - Public API
    
    func isEnabledFor(row: Int, column: Int) -> Bool {
        guard let cell = getCell(forRow: row, inColumn: column) else { return false }
        return cell.isEnabled
    }
    
    /// Indicates is current game is active
    /// - Returns: Boolean flag
    func isGameFinished() -> Bool { activeFieldsNumber == 1 }
    
    /// Returns Comet initial coordinates
    /// - Returns: Tuple of coordinates
    func getInitialCellCoordinats() -> (row: Int, column: Int) {
        guard let initialCell = fieldCells.filter( { $0.row == 0 && $0.isInitial }).first else { return (row: 0, column: 0) }
        return (row: initialCell.row, column: initialCell.column)
    }
    
    /// Sets state for the FieldCell with given coordinates
    /// - Parameters:
    ///   - state: New state
    ///   - row: Row of the Cell
    ///   - column: Column of the cell
    mutating func setState(_ state: FieldCellState, row: Int, column: Int) {
        guard var fieldCell = getCell(forRow: row, inColumn: column) else { return }
        guard fieldCell.currentState != state else { return }
        
        switch state {
        case .active:
            fieldCell.enable()
            node?.setTileGroup(Constants.gameTiles, forColumn: column, row: row )
        case .inActive:
            fieldCell.deactivate()
            node?.setTileGroup(Constants.inactiveTiles, forColumn: column, row: row )
            activeFieldsNumber -= 1
        case .current:
            fieldCell.activate()
            node?.setTileGroup(Constants.previousTiles, forColumn: column, row: row )
        case .none:
            fieldCell.disable()
            node?.setTileGroup(Constants.emptyTiles, forColumn: column, row: row )
        }
        
        fieldCells.append(fieldCell)
    }
    
    //MARK: - Internal Methods
    
    private func getCell(forRow: Int, inColumn: Int) -> GameFieldCell? {
        let gameFieldCells = fieldCells.filter { $0.column == inColumn && $0.row == forRow }
        
        return gameFieldCells.first
    }
    
    //MARK: - Generating Map
    
    private func generate() -> [[Int]] {
        var array = [[Int]]()

        let greatestColumnNumber = columns - 1
        let greatestRowNumber = rows - 1
        
        var maxNumber = Int.random(in: 4...30)
        
        for _ in 0...columns {
            var column = [Int]()
            for _ in 0...rows {
                column.append(0)
            }
            array.append(column)
        }
        
        let initialCellColumnIndex = Int.random(in: 0...greatestColumnNumber)
        var lastAddedCellColumnIndex = initialCellColumnIndex

        for column in 0...greatestColumnNumber {
            for row in 0...greatestRowNumber {
                if column == initialCellColumnIndex && row == 0 { array[column][row] = 1 }
                
                guard row != 0 else { continue }
                
                var addedIndexes = [Int]()
                
                if Bool.random() {
                    var randomStep = Int.random(in: lastAddedCellColumnIndex...greatestColumnNumber)
                    
                    if lastAddedCellColumnIndex + randomStep <= greatestColumnNumber {
                        while randomStep >= 0 {
                            if maxNumber >= 0 {
                                array[lastAddedCellColumnIndex + randomStep][row] = 1
                                addedIndexes.append(lastAddedCellColumnIndex + randomStep)
                                maxNumber -= 1
                            }

                            randomStep  -= 1
                        }
                        lastAddedCellColumnIndex = addedIndexes.first ?? lastAddedCellColumnIndex
                        
                    } else {
                        while !(lastAddedCellColumnIndex + randomStep <= lastAddedCellColumnIndex) {
                            randomStep -= 1
                        }

                        if lastAddedCellColumnIndex + randomStep <= greatestColumnNumber {
                        while randomStep >= 0 {
                            if maxNumber >= 0 {
                                array[lastAddedCellColumnIndex + randomStep][row] = 1
                                addedIndexes.append(lastAddedCellColumnIndex + randomStep)
                                maxNumber -= 1
                            }

                            randomStep  -= 1
                        }
                        lastAddedCellColumnIndex = addedIndexes.first ?? lastAddedCellColumnIndex
                        }
                    }
                } else {
                    var randomStep = Int.random(in: 0...lastAddedCellColumnIndex)
                    
                    if lastAddedCellColumnIndex - randomStep >= 0 {
                        while randomStep >= 0 {
                            if maxNumber >= 0 {
                                array[lastAddedCellColumnIndex - randomStep][row] = 1
                                addedIndexes.append(lastAddedCellColumnIndex - randomStep)
                                maxNumber -= 1
                            }
                            randomStep  -= 1
                        }
                        lastAddedCellColumnIndex = addedIndexes.first ?? lastAddedCellColumnIndex
                        
                    } else {
                        while !(lastAddedCellColumnIndex - randomStep >= 0) {
                            randomStep -= 1
                        }

                        if lastAddedCellColumnIndex - randomStep >= 0 {
                           while randomStep >= 0 {
                              if maxNumber >= 0 {
                                array[lastAddedCellColumnIndex - randomStep][row] = 1
                                addedIndexes.append(lastAddedCellColumnIndex - randomStep)
                                maxNumber -= 1
                            }

                            randomStep  -= 1
                           }
                           lastAddedCellColumnIndex = addedIndexes.first ?? lastAddedCellColumnIndex
                        }
                    }
                }
            }
        }
        
//        for row in (0...greatestRowNumber).reversed() {
//
//            var rowArr = [Int]()
//            for column in 0...greatestColumnNumber {
//                rowArr.append(array[column][row])
//            }
//            print(rowArr)
//        }
        
        return array
    }
    
    //MARK: - Initializers
    
    init(with tileMapNode: SKTileMapNode) {
        node = tileMapNode
        rows = tileMapNode.numberOfRows
        columns = tileMapNode.numberOfColumns
        activeFieldsNumber = 0
        
        let generatedArray = generate()
        
        for column in 0...columns - 1 {
            for row in 0...rows - 1 {
                let state: FieldCellState = generatedArray[column][row] == 1 ? .active : .none
                
                let isInitial = row == 0 && generatedArray[column][row] == 1
                
                fieldCells.append(GameFieldCell(row: row, column: column, state: state, isInitial: isInitial))
                if state == .active { activeFieldsNumber += 1 }
            }
            
        }
    }
}
