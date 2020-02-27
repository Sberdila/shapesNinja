//  Copyright © 2020 Dounia Belannab. All rights reserved.
//

import Foundation

enum Shape: Int {
    case box = 0
    case sphere
    case cylinder
    case torus
    case pyramid
    case cone

    static func random() -> Shape {
        let maxValue = cone.rawValue

        let rand = arc4random_uniform(UInt32(maxValue + 1))
        return Shape(rawValue: Int(rand))!
    }
}
