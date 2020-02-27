//  Copyright © 2020 Dounia Belannab. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit


class GameOverScene: SCNScene {
    var newScore: Int?
    var mainScene: SCNView?
    let highScore = ScoreHelper.getHighScore()


    func start(newScore: Int, mainScene: SCNView) -> GameOverScene {
        self.newScore = newScore
        buildScene(mainScene: mainScene)
        return self
    }
    
    func buildScene(mainScene: SCNView) {
        self.mainScene = mainScene
        buildScoreLabel()
        buildHighScoreLabel()
        buildLabelNode()
        buildReplayButton()
    }
    
    func buildScoreLabel() {
        let geometry = SCNText(string: "Score: \(newScore!)", extrusionDepth: 0)
        geometry.firstMaterial?.diffuse.contents = UIColor.white
        geometry.font = UIFont(name: "Arial", size: 1)
        let labelNode = SCNNode(geometry: geometry)
        labelNode.worldPosition = SCNVector3Make(-4, 4, 0)
        self.rootNode.addChildNode(labelNode)
    }
    
    func buildHighScoreLabel() {
        let geometry = SCNText(string: "High score: \(highScore)", extrusionDepth: 0)
        geometry.firstMaterial?.diffuse.contents = UIColor.white
        geometry.font = UIFont(name: "Arial", size: 1)
        let labelNode = SCNNode(geometry: geometry)
        labelNode.worldPosition = SCNVector3Make(-4, 2, 0)
        self.rootNode.addChildNode(labelNode)
    }
    
    func buildLabelNode() {
        let won = newScore! > highScore
        if won {
            ScoreHelper.storeScore(score: newScore!)
        }
        let message: String = won ? "You won :)" : "You lose :("
        let geometry = SCNText(string: "⭐️ \(message)", extrusionDepth: 0)
        geometry.firstMaterial?.diffuse.contents = won ? UIColor.green : UIColor.red
        geometry.font = UIFont(name: "Arial", size: 1)
        let labelNode = SCNNode(geometry: geometry)
        labelNode.worldPosition = SCNVector3Make(-4, 0, 0)
        self.rootNode.addChildNode(labelNode)
    }
    
    func buildReplayButton() {
        let geometry = SCNPlane(width: 7, height: 4)
        geometry.firstMaterial?.diffuse.contents = UIImage(named: "replay")
        let planNode = SCNNode(geometry: geometry)
        planNode.worldPosition = SCNVector3Make(0, -4, 0)
        self.rootNode.addChildNode(planNode)
    }
    
    func flipScene(mainScene: SCNView) {
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        let newGame = GameScene().start(mainSceneView: mainScene)
        mainScene.present(newGame, with: transition, incomingPointOfView: nil, completionHandler: nil)
    }
}
extension GameOverScene: GameSceneDelegate {
    func replay() {
        flipScene(mainScene: self.mainScene!)
    }
}
