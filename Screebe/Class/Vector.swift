import Foundation
import UIKit

class Vector {
    var StartPoint: Point
    var EndPoint: Point

    var cx: Double {
        get {
            return Double(StartPoint.x - EndPoint.x)
        }
    }
    
    var cy: Double {
        get {
            return Double(StartPoint.y - EndPoint.y)
        }
    }
    
    var norm: Double {
        get {
            return sqrt(pow(cx, 2) + pow(cy, 2))
        }
    }
    
    init(_ startPoint: CGPoint, _ endPoint: CGPoint) {
        StartPoint = Point(startPoint)
        EndPoint = Point(endPoint)
    }
    
    init(_ startPoint: Point, _ endPoint: Point) {
        StartPoint = startPoint
        EndPoint = endPoint
    }
    
    static func angle(_ v1: Vector, _ v2: Vector) -> Double {
        return acos(Vector.scalarProduct(v1, v2) / (v1.norm * v2.norm))
    }
    
    static func scalarProduct(_ v1: Vector, _ v2: Vector) -> Double {
        return v1.cx * v2.cx + v1.cy * v2.cy
    }
}
