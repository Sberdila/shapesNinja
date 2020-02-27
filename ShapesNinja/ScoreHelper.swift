//  Copyright © 2020 Dounia Belannab. All rights reserved.
//

import Foundation

class ScoreHelper {
    static func storeScore(score: Int) {
        UserDefaults.standard.setValue(score, forKey: "highScore")
    }
    static func getHighScore() -> Int {
        return UserDefaults.standard.integer(forKey: "highScore") 
    }
}
