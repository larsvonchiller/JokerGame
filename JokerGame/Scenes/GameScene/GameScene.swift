//
//  GameScene.swift
//  JokerGame
//
//  Created by Andrey Matoshko on 9/24/20.
//  Copyright © 2020 Andrey Matoshko. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    
    //MARK: - Nodes
    
    private var gameFieldNode: SKTileMapNode!
    private var cometNode: SKSpriteNode!
    private var gameOverNode: SKNode!
    private var againButtonNode: SKNode!
    private var youWinLabelNode: SKNode!
    private var tryAgainLabelNode: SKNode!
    
    //MARK: - Properties
    
    private var gameCoordinator = GameCoordinator()
    
    //MARK: - Scene Lifecycle
    
    override func didMove(to view: SKView) {
        addNodes()
        
        configSwipeRecognizers()
        gameOverNode.isHidden = true
        
        setupGameFieldNode()
        setupCometNode()
        startGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        let currentPosition = cometNode.position
        
        let tileRowIndex = gameFieldNode.tileRowIndex(fromPosition: currentPosition)
        let tileColumnIndex = gameFieldNode.tileColumnIndex(fromPosition: currentPosition)
        
        if isGameFinished() {
            finishGame()
        } else if isGameValidFor(tileRow: tileRowIndex, tileColumn: tileColumnIndex) {
            gameCoordinator.updateCometPosition(row: tileRowIndex, column: tileColumnIndex)
        } else {
            stopGame()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if againButtonNode.contains(location) && !gameOverNode.isHidden {
                gameOverNode.isHidden = true

                setupGameFieldNode()
                setupCometNode()

                startGame()
            }
        }
    }
    
    //MARK: - Setup UI
    
    private func addNodes() {
        guard let containerNode = scene?.childNode(withName: "ContainerNode" ) else { return }
        guard let tileMapNode = containerNode.childNode(withName: "GameFiledNode") as? SKTileMapNode else { return }
        guard let cometSpriteNode = tileMapNode.childNode(withName: "CometNode") as? SKSpriteNode else { return }
        guard let gameOverContainerNode = containerNode.childNode(withName: "GameOverContainerNode" ) else { return }
        guard let tryAgainButtonNode = gameOverContainerNode.childNode(withName: "TryAgainButtonNode" ) else { return }
        guard let tryAgainNode = gameOverContainerNode.childNode(withName: "TryAgainNode") else { return }
        guard let youWinNode = gameOverContainerNode.childNode(withName: "YouWinNode") else { return }
               
        gameFieldNode = tileMapNode
        cometNode = cometSpriteNode
        gameOverNode = gameOverContainerNode
        againButtonNode = tryAgainButtonNode
        youWinLabelNode = youWinNode
        tryAgainLabelNode = tryAgainNode
    }
    
    //MARK: - Swipen Recognizers
    
    private func configSwipeRecognizers() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeRight(sender:)))
        swipeRight.direction = .right
        view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeLeft(sender:)))
        swipeLeft.direction = .left
        view?.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeDown(sender:)))
        swipeDown.direction = .down
        view?.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeUp(sender:)))
        swipeUp.direction = .up
        view?.addGestureRecognizer(swipeUp)
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        cometNode.removeAllActions()
        
        let rotationAction = SKAction.rotate(toAngle: 0, duration: 0.05, shortestUnitArc: true)
        let mainAction = SKAction.move(by: CGVector(dx: 700, dy: 0), duration: 4)
        
        cometNode.run(rotationAction)
        cometNode.run(mainAction)
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        cometNode.removeAllActions()
        
        
        let rotationAction = SKAction.rotate(toAngle: 3.14, duration: 0.05, shortestUnitArc: true)
        let mainAction = SKAction.move(by: CGVector(dx: -700, dy: 0), duration: 4)
           
        cometNode.run(rotationAction)
        cometNode.run(mainAction)
    }
    
    @objc func swipeDown(sender: UISwipeGestureRecognizer) {
        cometNode.removeAllActions()
        
        let rotationAction = SKAction.rotate(toAngle: -1.57, duration: 0.05, shortestUnitArc: true)
        let mainAction = SKAction.move(by: CGVector(dx: 0, dy: -700), duration: 4)
           
        cometNode.run(rotationAction)
        cometNode.run(mainAction)
    }
    
    @objc func swipeUp(sender: UISwipeGestureRecognizer) {
        cometNode.removeAllActions()
        let rotationAction = SKAction.rotate(toAngle: 1.57, duration: 0.05, shortestUnitArc: true)
        let mainAction = SKAction.move(by: CGVector(dx: 0, dy: 700), duration: 4)
           
        cometNode.run(rotationAction)
        cometNode.run(mainAction)
    }
    
   //MARK: - Game Setup
    
    private func setupGameFieldNode() {
        gameCoordinator.addMap(Map(with: gameFieldNode))
        
        for column in 0...gameFieldNode.numberOfColumns {
            for row in 0...gameFieldNode.numberOfRows {
                if gameCoordinator.isGameFieldEnabled(row: row, column: column) {
                    gameFieldNode.setTileGroup(Constants.gameTiles, forColumn: column, row: row)
                } else {
                    gameFieldNode.setTileGroup(Constants.emptyTiles, forColumn: column, row: row)
                }
            }
        }
    }
    
    private func setupCometNode() {
        gameCoordinator.addComet(Comet(with: cometNode))
        
        let cometCoordinates = gameCoordinator.getCometInitialCoordinates()
        let initialPosition = gameFieldNode.centerOfTile(atColumn: cometCoordinates.column, row: cometCoordinates.row)
        
        cometNode.position = initialPosition
    }
  
    //MARK: - Game Actions
    
    private func startGame() {
        let mainAction = SKAction.move(by: CGVector(dx: 0, dy: 700), duration: 4)
           
        cometNode.zRotation = 1.57
        cometNode.run(mainAction)
    }
       
    private func stopGame() {
        cometNode.removeAllActions()
        
        gameOverNode.isHidden = false
        tryAgainLabelNode.isHidden = false
        youWinLabelNode.isHidden = true
    }
    
    private func finishGame() {
        cometNode.removeAllActions()
        
        gameOverNode.isHidden = false
        tryAgainLabelNode.isHidden = true
        youWinLabelNode.isHidden = false
    }

    private func isCometBelongsToTile(with centerPoint: CGPoint) -> Bool {
        let cometX = cometNode.position.x
        let cometY = cometNode.position.y
        
        let minX = centerPoint.x - 50
        let maxX = centerPoint.x + 50
    
        let minY = centerPoint.y - 50
        let maxY = centerPoint.y + 50
        
        if cometX >= minX && cometX <= maxX && cometY <= maxY && cometY >= minY {
            return true
        } else {
            return false
        }
    }
    
    private func isGameValidFor(tileRow: Int, tileColumn: Int) -> Bool {
        let tileCenterPoint = gameFieldNode.centerOfTile(atColumn: tileColumn, row: tileRow)
        
        guard isCometBelongsToTile(with: tileCenterPoint) else { return false }
        
        let tileGroup = gameFieldNode.tileGroup(atColumn: tileColumn, row: tileRow)
        
        guard tileGroup?.name == "Current" || tileGroup?.name == "Active" else { return false }
        
        return true
    }
    
    private func isGameFinished() -> Bool { gameCoordinator.isGameFinished() }
}
