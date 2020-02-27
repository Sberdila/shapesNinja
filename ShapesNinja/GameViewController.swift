//  Copyright © 2020 Dounia Belannab. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {

    weak var gameScene: SCNScene?

    override func viewDidLoad() {

        super.viewDidLoad()
        if let view = self.view as? SCNView {
            view.backgroundColor = UIColor.black
            gameScene = GameScene().start(mainSceneView: view)
            view.scene = self.gameScene
            view.autoenablesDefaultLighting = true
        }
    }
}

extension GameViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let gameScene = self.gameScene as? GameScene else {return}
        gameScene.touchesBegan(touches, with: event)
    }
}

