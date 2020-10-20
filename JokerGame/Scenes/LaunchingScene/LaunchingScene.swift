//
//  LaunchingScene.swift
//  JokerGame
//
//  Created by Andrey Matoshko on 9/24/20.
//  Copyright © 2020 Andrey Matoshko. All rights reserved.
//

import UIKit
import SpriteKit

class LaunchingScene: SKScene {
    
    //MARK: - Properties
    
    private var cometContainerNode: SKNode!
    
    //MARK: - Methods

    override func didMove(to view: SKView) {
        guard let mainScene = SKScene(fileNamed: "MainScene") else { return }
        mainScene.scaleMode = .aspectFit
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            let reveal = SKTransition.reveal(with: .up, duration: 1)
                
            self?.scene?.view?.presentScene(mainScene, transition: reveal)
        }
    }
    
}
