//
//  FaceIt.swift
//  faceit
//
//  Created by Philippe Vinchon on 30/07/2017.
//  Copyright © 2017 Philippe Vinchon. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var smileyScale: CGFloat = 0.9

    @IBInspectable
    var eyesOpen: Bool = false

    @IBInspectable
    var strokeLineWidth: CGFloat = 3.0

    @IBInspectable
    var strokeLineColor: UIColor = UIColor.blue

    func updatePath(_ path: UIBezierPath) -> UIBezierPath {
        path.lineWidth = strokeLineWidth
        return path
    }

    func drawCircle(center: CGPoint, radius: CGFloat, color: UIColor) {
        let circle = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        UIColor.black.set()
        circle.stroke()

        color.set()
        circle.fill()
    }

    func smileyCenter() -> CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    func smileyRadius() -> CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * smileyScale
    }

    func smileyPath() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: smileyCenter(), radius: smileyRadius(), startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        return updatePath(path)
    }

    enum Eye: CGFloat {
        case Left = 1
        case Right = -1
    }

    func eyeCenter(_ eye: Eye) -> CGPoint {
        let radius = smileyRadius()
        let transform = CGAffineTransform(translationX: radius * eye.rawValue * 0.45, y: radius * -0.5)

        return smileyCenter().applying(transform)
    }

    func eyeRadius() -> CGFloat {
        return smileyRadius() * 0.2
    }

    func eyePath(_ eye: Eye) -> UIBezierPath {
        let getPath: (CGPoint, CGFloat) -> UIBezierPath
        if eyesOpen {
            getPath = { UIBezierPath(arcCenter: $0, radius: $1, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true) }
        } else {
            getPath = {
                let line = UIBezierPath()
                line.move(to: CGPoint(x: $0.x - $1, y: $0.y))
                line.addLine(to: CGPoint(x: $0.x + $1, y:$0.y))

                return line
            }
        }

        let path = getPath(eyeCenter(eye), eyeRadius())
        return updatePath(path)
    }

    func mouthPath() -> UIBezierPath {
        let radius = smileyRadius()

        let mouthWidth = radius * 0.9
        let mouthHeight = radius * 0.2
        let mouthOffset = radius * 0.4

        let rect = CGRect(
            x: smileyCenter().x - mouthWidth / 2,
            y: smileyCenter().y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight)

        let path = UIBezierPath(rect: rect)
        return updatePath(path)
    }

    override func draw(_ rect: CGRect) {
        strokeLineColor.setStroke()

        smileyPath().stroke()
        eyePath(Eye.Left).stroke()
        eyePath(Eye.Right).stroke()
        mouthPath().stroke()
    }
    
}
