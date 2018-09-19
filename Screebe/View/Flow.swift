import Foundation
import UIKit

class Flow : UIView {
    private let lineWidth: CGFloat = 3
    private let drawingBuffer = 1000 // Put X points on ram before transforming it into a CALayerShape
    private var shape = CAShapeLayer()
    private var clippingPath: UIBezierPath = UIBezierPath() // It prevent the clipping when you add a subShape
    private var path: UIBezierPath = UIBezierPath() // The
    private var lastPoint: Point!
    private var counterToApply = 0
    private var close = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, startTouch: UITouch) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0)
        layer.addSublayer(shape)
        path.lineWidth = lineWidth
        clippingPath.lineWidth = lineWidth
        lastPoint = Point(startTouch, self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        close = false
        lastPoint = Point(touches.first!, self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = Point(touch, self)
        if Vector(lastPoint, point).norm > 1 {
            path.move(to: lastPoint.Location)
            path.addLine(to: point.Location)
            setNeedsDisplay()
            lastPoint = point
            counterToApply += 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        close = true
        lastPoint = nil
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
            shape.addSublayer(subShape)
            if !close {
                clippingPath.cgPath = path.cgPath
            }
            path.removeAllPoints()
            counterToApply = 0
        }
    }
}
