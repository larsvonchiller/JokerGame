//
//  Constants.swift
//  JokerGame
//
//  Created by Andrey Matoshko on 10/12/20.
//  Copyright © 2020 Andrey Matoshko. All rights reserved.
//

import Foundation
import SpriteKit

struct Constants {
    static let tileSet = SKTileSet(named: "Main")
    
    static var gameTiles: SKTileGroup { tileSet!.tileGroups.first { $0.name == "Active" }! }
    static var inactiveTiles: SKTileGroup { tileSet!.tileGroups.first { $0.name == "InActive"}! }
    static var previousTiles: SKTileGroup { tileSet!.tileGroups.first { $0.name == "Current"}! }
    static var emptyTiles: SKTileGroup { tileSet!.tileGroups.first { $0.name == "Empty" }! }
}
