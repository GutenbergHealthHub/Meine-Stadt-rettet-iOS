//
//  ERSignatureAreaView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 10.11.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit


protocol ERSignatureAreaViewDelegate: NSObjectProtocol {
    func signatureAreaViewDidStartDrawing(signatureAreaView: ERSignatureAreaView)
    func signatureAreaViewDidStopDrawing(signatureAreaView: ERSignatureAreaView)
}

class ERSignatureAreaView: UIView {
    
    private static var strokeWidth: CGFloat = 2.0
    
    weak var delegate: ERSignatureAreaViewDelegate?
    
    var signatureImage: UIImage? { return getSignature() }
    var containsSignature: Bool { return !path.isEmpty }
    
    // MARK: - Private properties
    private var path = UIBezierPath()
    private var points = [CGPoint](repeating: CGPoint(), count: 5)
    private var controlPoint = 0
    
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.white
        
        layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        layer.borderWidth = 2
        
        path.lineWidth = ERSignatureAreaView.strokeWidth
        path.lineJoinStyle = CGLineJoin.round
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Draw
    override public func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        path.stroke()
    }
    
    // MARK: - Touch handling functions
    override public func touchesBegan(_ touches: Set <UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            self.controlPoint = 0
            self.points[0] = touchPoint
        }
        
        delegate?.signatureAreaViewDidStartDrawing(signatureAreaView: self)
    }
    
    override public func touchesMoved(_ touches: Set <UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            self.controlPoint += 1
            self.points[self.controlPoint] = touchPoint
            if (self.controlPoint == 4) {
                self.points[3] = CGPoint(x: (self.points[2].x + self.points[4].x)/2.0, y: (self.points[2].y + self.points[4].y)/2.0)
                self.path.move(to: self.points[0])
                self.path.addCurve(to: self.points[3], controlPoint1:self.points[1], controlPoint2:self.points[2])
                
                self.setNeedsDisplay()
                self.points[0] = self.points[3]
                self.points[1] = self.points[4]
                self.controlPoint = 1
            }
            
            self.setNeedsDisplay()
        }
    }
    
    override public func touchesEnded(_ touches: Set <UITouch>, with event: UIEvent?) {
        if self.controlPoint == 0 {
            let touchPoint = self.points[0]
            self.path.move(to: CGPoint(x: touchPoint.x-1.0,y: touchPoint.y))
            self.path.addLine(to: CGPoint(x: touchPoint.x+1.0,y: touchPoint.y))
            self.setNeedsDisplay()
        } else {
            self.controlPoint = 0
        }
        
        delegate?.signatureAreaViewDidStopDrawing(signatureAreaView: self)
    }
    
    // MARK: - Methods for interacting with Signature View
    
    // Clear the Signature View
    public func clear() {
        path.removeAllPoints()
        setNeedsDisplay()
    }
    
    // Save the Signature as an UIImage
    public func getSignature(scale:CGFloat = 1) -> UIImage? {
        if !containsSignature { return nil }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        self.path.stroke()
        let signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return signature
    }
    
    // Save the Signature (cropped of outside white space) as a UIImage
    public func getCroppedSignature(scale:CGFloat = 1) -> UIImage? {
        guard let fullRender = getSignature(scale:scale) else { return nil }
        let bounds = self.scale(path.bounds.insetBy(dx: -ERSignatureAreaView.strokeWidth/2, dy: -ERSignatureAreaView.strokeWidth/2), byFactor: scale)
        guard let imageRef = fullRender.cgImage?.cropping(to: bounds) else { return nil }
        return UIImage(cgImage: imageRef)
    }
    
    
    private func scale(_ rect: CGRect, byFactor factor: CGFloat) -> CGRect
    {
        var scaledRect = rect
        scaledRect.origin.x *= factor
        scaledRect.origin.y *= factor
        scaledRect.size.width *= factor
        scaledRect.size.height *= factor
        return scaledRect
    }
}
