import Foundation
import UIKit

class Vector {
    var StartPoint: Point
    var EndPoint: Point

    var CX: Double {
        get {
            return Double(StartPoint.x - EndPoint.x)
        }
    }
    
    var CY: Double {
        get {
            return Double(StartPoint.y - EndPoint.y)
        }
    }
    
    var Norm: Double {
        get {
            return sqrt(pow(CX, 2) + pow(CX, 2))
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
        return acos(Vector.scalarProduct(v1, v2) / (v1.Norm * v2.Norm))
    }
    
    static func scalarProduct(_ v1: Vector, _ v2: Vector) -> Double {
        return v1.CX * v2.CX + v1.CY * v2.CY
    }
}
