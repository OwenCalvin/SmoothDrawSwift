import Foundation
import UIKit

class Flow : UIView {
    private var estimates: [NSNumber: Point] = [:]
    private var points: [Point] = []
    private var color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    private let lineWidth: CGFloat = 2
    private var frozen: Bool = false
    private var processedPoints: [Point] = []
    private var writingPoints: [Point] = []
    private let writingBuffer = 40
    private let layers: [CGContext] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, startTouch: UITouch) {
        super.init(frame: frame)
        let point = startTouch.location(in: self)
        points.append(Point(point, startTouch.force))
        backgroundColor = UIColor(white: 0, alpha: 0)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = Point(touch.location(in: self), touch.force)
        if canApply(point) {
            writingPoints.append(point)
            /*
             if (touch.estimatedPropertiesExpectingUpdates.contains(.force)) {
             estimates[touch.estimationUpdateIndex!] = Point
             }
             */
            setNeedsDisplay()
        }
    }
    
    private func canApply(_ point: Point) -> Bool {
        if (!frozen) {
            if (writingPoints.count > 0) {
                return Vector(writingPoints[writingPoints.count - 1], point).norm > 1
            }
            return true
        }
        return false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        frozen = true
    }

    override func draw (_ rect: CGRect) {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        context?.setLineJoin(.round)
        context?.setLineCap(.round)
        context?.setStrokeColor(color.cgColor)
        context?.setLineWidth(lineWidth)
        
        if (writingPoints.count > 2) {
            for i in 0..<writingPoints.count - 1 {
                context?.move(to: writingPoints[i].Location)
                context?.addLine(to: writingPoints[i + 1].Location)
                context?.strokePath()
            }
        }
        
        var i: Int = 0
        if (writingPoints.count > writingBuffer) {
            while i < writingPoints.count {
                if i > 0 {
                    let actualPoint = writingPoints[i]
                    let previousPoint = writingPoints[i - 1]
                    
                    // A is the previous point
                    // B is the current point
                    // C is the next point
                    let vBA = Vector(actualPoint, previousPoint)
                    let normOkay = vBA.norm > 2
                    
                    
                    // Do not add point that have a flat angle
                    if i < writingPoints.count - 1 {
                        let nextPoint = writingPoints[i + 1]
                        let vBC = Vector(actualPoint, nextPoint)
                        let angle = Vector.angle(vBA, vBC)
                        let angleOkay = angle < Double.pi - 0.1
                        if angleOkay && normOkay {
                            processedPoints.append(writingPoints[i])
                        }
                    } else if normOkay {
                        processedPoints.append(writingPoints[i])
                    }
                }
                i += 1
            }
        }
        
        i = 1
        while i < processedPoints.count - 1 {
            context?.setStrokeColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
            let previousPoint = processedPoints[i - 1]
            let actualPoint = processedPoints[i]
            let nextPoint = processedPoints[i + 1]
            
            // Draw
            let crPoints = [
                previousPoint,
                actualPoint,
                nextPoint,
                i < processedPoints.count - 2 ? processedPoints[i + 2] : nextPoint
            ]
            
            let vAB = Vector(actualPoint, nextPoint)
            let to: Int = Int((vAB.norm / 25).rounded(.up))
            print(vAB.norm, to)
            
            var lastCRPoint: Point! = actualPoint
            for j in 0...to {
                let newCRPoint = Point.CatmullRom2D(
                    Double(j) * (1 / Double(to)),
                    crPoints.first!,
                    crPoints[1],
                    crPoints[2],
                    crPoints.last!
                )
                context?.setLineJoin(.bevel)
                context?.setLineCap(.butt)
                context?.beginPath()
                context?.move(to: lastCRPoint.Location)
                context?.addLine(to: newCRPoint.Location)
                // context?.setStrokeColor(UIColor(red: 0, green: 255, blue: 0, alpha: 1).cgColor)
                // context?.addEllipse(in: CGRect(x: newCRPoint.x - 1, y: newCRPoint.y - 1, width: 2, height: 2))
                context?.strokePath()
                lastCRPoint = newCRPoint
            }
            // context?.setStrokeColor(UIColor(red: 255, green: 0, blue: 0, alpha: 1).cgColor)
            // context?.addEllipse(in: CGRect(x: processedPoints[i].x - 1, y: processedPoints[i].y - 1, width: 2, height: 1))
            // context?.strokePath()
            i += 1
        }
        
        if (writingPoints.count > writingBuffer) {
            writingPoints = [processedPoints.last!]
        }
        UIGraphicsEndImageContext()
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        for touch in touches {
            if !touch.estimatedPropertiesExpectingUpdates.contains(.force) {
                let index = touch.estimationUpdateIndex!
                estimates[index]?.Force = touch.force
                estimates.removeValue(forKey: index)
                setNeedsDisplay()
            }
        }
    }
}
