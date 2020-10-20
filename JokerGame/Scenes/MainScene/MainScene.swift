//
//  MainScene.swift
//  JokerGame
//
//  Created by Andrey Matoshko on 9/24/20.
//  Copyright © 2020 Andrey Matoshko. All rights reserved.
//

import UIKit
import SpriteKit

class MainScene: SKScene {

    private var playButtonNode: SKNode!
    
    override func didMove(to view: SKView) {
        guard let containerNode = scene?.childNode(withName: "ContainerNode") else { return }
        playButtonNode = containerNode.childNode(withName: "ButtonNode")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if playButtonNode.contains(location) {
                guard let gameScene = SKScene(fileNamed: "GameScene") else { return }
                gameScene.scaleMode = .aspectFit
                
                let reveal = SKTransition.fade(withDuration: 2)
                    
                scene?.view?.presentScene(gameScene, transition: reveal)
            }
        }
    }
    
}
