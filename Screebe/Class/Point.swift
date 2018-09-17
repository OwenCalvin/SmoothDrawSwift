import Foundation
import UIKit

class Point {
    var Force: CGFloat!
    var Location: CGPoint
    var Processed: Bool = false
    
    var x: Int {
        get {
            return Int(Location.x)
        }
    }
    
    var y: Int {
        get {
            return Int(Location.y)
        }
    }

    init (_ point: CGPoint) {
        Location = point
        Force = 1
    }
    
    init (_ point: CGPoint, _ force: CGFloat) {
        Location = point
        Force = force
    }

    init (x: Int, y: Int, force: CGFloat) {
        Location = CGPoint(x: CGFloat(x), y: CGFloat(y))
        Force = force
    }
    
    init (x: Int, y: Int) {
        Location = CGPoint(x: CGFloat(x), y: CGFloat(y))
        Force = 1
    }
    
    static func CatmullRom(_ t: Double, _ p0: Int, _ p1: Int, _ p2: Int, _ p3: Int) -> Double {
        let a = Double(3 * p1 - p0 - 3 * p2 + p3)
        let b = Double(2 * p0 - 5 * p1 + 4 * p2 - p3)
        let c = Double(p2 - p0) * t
        let d = Double(2 * p1)
        return 0.5 * (a * pow(t, 3) + b * pow(t, 2) + c + d)
    }
    
    static func CatmullRom2D(_ t: Double, _ p0: Point, _ p1: Point, _ p2: Point, _ p3: Point) -> Point {
        return Point(x: Int(CatmullRom(t, p0.x, p1.x, p2.x, p3.x)), y: Int(CatmullRom(t, p0.y, p1.y, p2.y, p3.y)))
    }
}
