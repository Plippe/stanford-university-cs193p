//
//  ViewController.swift
//  faceit
//
//  Created by Philippe Vinchon on 30/07/2017.
//  Copyright © 2017 Philippe Vinchon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            updateFaceView()

            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(faceView.updateSmileyScale(reactTo:))))
            faceView.addGestureRecognizer(UITapGestureRecognizer(target: faceView, action: #selector(faceView.toggleEyesOpen(reactTo:))))
        }
    }

    var expression = FacialExpression(eyes: .open, mouth: .grin) {
        didSet { updateFaceView() }
    }
    
    private func updateFaceView() {
        switch expression.eyes {
        case .open: faceView?.eyesOpen = true
        case .closed: faceView?.eyesOpen = false
        case .squinting: faceView?.eyesOpen = false
        }

        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }

    private let mouthCurvatures = [
        FacialExpression.Mouth.smile:1.0,
        .grin: 0.5,
        .neutral:0,
        .smirk:-0.5,
        .frown:-1
    ]
    
}

