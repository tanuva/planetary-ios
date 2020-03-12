//
//  CircleView.swift
//  Planetary
//
//  Created by Martin Dutra on 3/12/20.
//  Copyright © 2020 Verse Communications Inc. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    private let dotSize: CGFloat = 5
    private let dotColor = #colorLiteral(red: 0.9952326417, green: 0.1234170869, blue: 0.2947148085, alpha: 1)
    private let rotationSpeed: TimeInterval = 4.1
    
    private var strokeView: UIView
    private var animationLayer: CALayer?
    
    override init(frame: CGRect) {
        self.strokeView = UIView.forAutoLayout()
        super.init(frame: frame)
        Layout.fill(view: self, with: self.strokeView)
        self.strokeView.stroke()
        self.clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.strokeView.round()
    }
    
    func startAnimating() {
        stopAnimating()
        animationLayer = addAnimationLayer(color: self.dotColor,
                                           size: self.bounds.width,
                                           rotationSpeed: self.rotationSpeed)
    }
    
    func stopAnimating() {
        animationLayer?.removeAllAnimations()
        animationLayer?.removeFromSuperlayer()
    }
    
    private func addAnimationLayer(color: UIColor, size: CGFloat, rotationSpeed: TimeInterval) -> CALayer {
        let replicatorLayer = CALayer()
        replicatorLayer.position = CGPoint.zero
        replicatorLayer.frame = self.bounds

        let circle = CALayer()
        // 1.5 is the strokeView's border radius
        circle.frame = CGRect(x: self.bounds.midX, y: -1.5, width: dotSize, height: dotSize)
        circle.cornerRadius = dotSize / 2
        circle.backgroundColor = color.cgColor

        replicatorLayer.addSublayer(circle)

        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = rotationSpeed
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = .greatestFiniteMagnitude
        replicatorLayer.add(rotation, forKey: "rotation")

        self.layer.addSublayer(replicatorLayer)

        return replicatorLayer
    }
    
}
