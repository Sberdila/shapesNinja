//
//  GameScene.swift
//  ShapesNinja
//
//  Created by Dounia Belannab on 2/6/20.
//  Copyright © 2020 Dounia Belannab. All rights reserved.
//

import SpriteKit
import SceneKit
//import GameplayKit

protocol GameSceneDelegate: class {
    func replay()
}

class GameScene: SCNScene {

    weak var delegate: GameSceneDelegate?
    var mainView: SCNView?
    var spawnTime = 0.0
    var score = 0
    var timer: Int = 15
    var cameraNode: SCNNode?
    var scoreNode: SCNNode?
    var timerNode: SCNNode?
    func start(mainSceneView: SCNView) -> SCNScene {
        mainView = mainSceneView
        mainView?.delegate = self
        addCamera()
        addScoreNode()
        addTimerNode()
        addThreeShapes()
        return self
    }

    private func addScoreNode() {
        let geometry = SCNText(string: "\(score)", extrusionDepth: 0)
        geometry.firstMaterial?.diffuse.contents = UIColor.white
        geometry.font = UIFont(name: "Arial", size: 1)
        self.scoreNode = SCNNode(geometry: geometry)
        self.scoreNode?.worldPosition = SCNVector3Make(-2, 8, 0)
        self.rootNode.addChildNode(self.scoreNode!)
    }

    private func addCamera() {
        cameraNode = SCNNode()
        cameraNode?.camera = SCNCamera()
        cameraNode?.position = SCNVector3Make(0, 0, 20)
        self.rootNode.addChildNode(cameraNode!)
    }

    private func addThreeShapes() {
        for _ in 1...3 {
            addShape()
        }
    }

    private func shakeIt(node: SCNNode) {
        node.physicsBody = .dynamic()
        node.physicsBody?.applyForce(SCNVector3(0, Double.random(in: 0...20), 0), asImpulse: true)
    }

    private func addShape() {
        let geometry = makeGeometry(shape: Shape.random())
        self.addRandomColor(geometry: geometry)
        let node = SCNNode(geometry: geometry)
        shakeIt(node: node)
        self.rootNode.addChildNode(node)
    }

    private func addRandomColor(geometry: SCNGeometry) {
        let randomRed: CGFloat = CGFloat(Double.random(in: 0...256) / 256)
        let randomBlue: CGFloat = CGFloat(Double.random(in: 0...256) / 256)
        let randomGreen: CGFloat = CGFloat(Double.random(in: 0...256) / 256)
        geometry.firstMaterial?.diffuse.contents = UIColor.init(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1)

    }
    private func makeGeometry(shape: Shape) -> SCNGeometry {
        switch shape {
        case .box:
            return SCNBox()
        case .cone:
            return SCNCone()
        case .cylinder:
            return SCNCylinder()
        case .pyramid:
            return SCNPyramid()
        case .sphere:
            return SCNSphere()
        case .torus:
            return SCNTorus()

        }
    }

    private func clearShapes() {
        for node in self.rootNode.childNodes {
            if node.position.y < -6 {
                node.removeFromParentNode()
            }
        }
    }
    private func addTimerNode() {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(incrementTimer), userInfo: nil, repeats: true)
        let geometry = SCNText(string: "00:\(timer)", extrusionDepth: 0)
        geometry.firstMaterial?.diffuse.contents = UIColor.white
        geometry.font = UIFont(name: "Arial", size: 1)
        self.timerNode = SCNNode(geometry: geometry)
        self.timerNode?.worldPosition = SCNVector3Make(-7, 8, 0)
        self.rootNode.addChildNode(self.timerNode!)
    }

    private func updateScore() {
        let geo = self.scoreNode?.geometry as? SCNText
        geo?.string = "\(score)"
    }

    @objc func incrementTimer() {
        if timer == 0 {
            timer -= 1
            self.endGame()
            return
        }
        if timer == -1 {
            return
        }
        timer -= 1
        let geo = self.timerNode?.geometry as? SCNText
        geo?.string = "00:\(timer)"
    }
    func endGame() {
        let gameoverscene = GameOverScene().start(newScore: score, mainScene: mainView!)
        self.delegate =  gameoverscene
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        mainView!.present(gameoverscene, with: transition, incomingPointOfView: self.cameraNode, completionHandler: nil)
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let position = touch?.location(in: self.mainView)
        let hits = self.mainView?.hitTest(position!, options: nil)
        if let touchedNode = hits?.first {
            if let _ = touchedNode.node.geometry as? SCNText {
                return
            }
            if let _ = touchedNode.node.geometry as? SCNPlane {
                self.delegate?.replay()
                return
            }
            touchedNode.node.removeFromParentNode()
            score += 1
            updateScore()
        }
    }
    
}

extension GameScene: SCNSceneRendererDelegate {

    func renderer(_ renderer: SCNSceneRenderer,
        updateAtTime time: TimeInterval) {
        if time > spawnTime {
            self.clearShapes()
            self.addThreeShapes()
            spawnTime = time + TimeInterval(Float.random(in: 0.2...0.5))
        }
    }
}
