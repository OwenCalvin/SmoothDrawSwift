import Foundation
import UIKit

class Draw : UIView {
    private let drawingBuffer = 200 // Put X points on ram before transforming it into a CALayerShape
    private var clippingPath: UIBezierPath = UIBezierPath() // It prevent the clipping when you add a subShape
    private var path: UIBezierPath = UIBezierPath() // The
    private var curvePoints: [CGPoint] = []
    private var counterToApply = 0
    private var close = false
    private let lineWidth: CGFloat = 3
    private let curveBuffer = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        construct()
    }
    
    func construct() {
        path.lineWidth = lineWidth
        path.lineCapStyle = CGLineCap.round
        path.lineJoinStyle = CGLineJoin.round
        clippingPath = path
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        curvePoints.append(touches.first!.location(in: self))
        close = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent!) {
        let touch = touches.first!
        let point = touch.location(in: self)
        if Vector(curvePoints.last!, point).Norm > 0.1 {
            let bufferOkay = curvePoints.count >= curveBuffer
            path.move(to: curvePoints.last!)
            path.addCurve(
                to: point,
                controlPoint1: curvePoints.count >= 2 ? curvePoints[1] : curvePoints.last!,
                controlPoint2: bufferOkay ? curvePoints[2] : curvePoints.last!)
            setNeedsDisplay()
            curvePoints.append(point)
            if curvePoints.count >= curveBuffer {
                curvePoints.remove(at: 0)
            }
            counterToApply += 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        close = true
        curvePoints = []
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        path.stroke()
        clippingPath.stroke()
        if counterToApply == drawingBuffer || close {
            let subShape = CAShapeLayer()
            subShape.lineWidth = lineWidth
            subShape.strokeColor = UIColor.black.cgColor
            subShape.lineCap = CAShapeLayerLineCap.round
            subShape.lineJoin = CAShapeLayerLineJoin.round
            subShape.path = path.cgPath
            layer.addSublayer(subShape)
            if !close {
                clippingPath.cgPath = path.cgPath
            }
            path.removeAllPoints()
            counterToApply = 0
        }
    }
}
