//
//  UIBezierPath.swift
//  EcoRescue
//
//  Created by Christoph Erl on 10.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    class func pin(rect: CGRect, arrowHeight: CGFloat) -> UIBezierPath {
        
        var circleFrame     = rect; circleFrame.size.height -= arrowHeight
        let circleCenter    = CGPoint(x: circleFrame.midX, y: circleFrame.midY)
        let radius          = circleFrame.width / 2
        
        let startAngle  = ERUtil.degreesToRadians(110)
        let endAngle    = ERUtil.degreesToRadians(70)
    
        let pointArrowTL = CGPoint(x: circleCenter.x + radius * cos(startAngle), y: circleCenter.y + radius * sin(startAngle))
        let pointArrowTR = CGPoint(x: circleCenter.x + radius * cos(endAngle), y: circleCenter.y + radius * sin(endAngle))
        let pointArrowB  = CGPoint(x: rect.midX, y: rect.maxY)
        let pointArrowT  = CGPoint(x: rect.midX, y: rect.maxY - arrowHeight)
        
        let bezierPath = UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        bezierPath.move(to: pointArrowTR)
        bezierPath.addQuadCurve(to: pointArrowB, controlPoint: pointArrowT)
        bezierPath.addQuadCurve(to: pointArrowTL, controlPoint: pointArrowT)
        
        //bezierPath.close()
        return bezierPath
    }
    
    
        class func getHearts(_ originalRect: CGRect, scale: Double) -> UIBezierPath {
            
            let bezierPath = UIBezierPath()
            
            //Scaling will take bounds from the originalRect passed
            let scaledWidth = (originalRect.size.width * CGFloat(scale))
            let scaledXValue = ((originalRect.size.width) - scaledWidth) / 2
            let scaledHeight = (originalRect.size.height * CGFloat(scale))
            let scaledYValue = ((originalRect.size.height) - scaledHeight) / 2
            
            let scaledRect = CGRect(x: scaledXValue, y: scaledYValue, width: scaledWidth, height: scaledHeight)
            bezierPath.move(to: CGPoint(x: originalRect.size.width/2, y: scaledRect.origin.y + scaledRect.size.height))
            
            bezierPath.addCurve(to: CGPoint(x: scaledRect.origin.x, y: scaledRect.origin.y + (scaledRect.size.height/4)),
                                 controlPoint1:CGPoint(x: scaledRect.origin.x + (scaledRect.size.width/2), y: scaledRect.origin.y + (scaledRect.size.height*3/4)) ,
                                 controlPoint2: CGPoint(x: scaledRect.origin.x, y: scaledRect.origin.y + (scaledRect.size.height/2)) )
            
            bezierPath.addArc(withCenter: CGPoint( x: scaledRect.origin.x + (scaledRect.size.width/4),y: scaledRect.origin.y + (scaledRect.size.height/4)),
                                  radius: (scaledRect.size.width/4),
                                  startAngle: CGFloat(M_PI),
                                  endAngle: 0,
                                  clockwise: true)
            
            bezierPath.addArc(withCenter: CGPoint( x: scaledRect.origin.x + (scaledRect.size.width * 3/4),y: scaledRect.origin.y + (scaledRect.size.height/4)),
                                  radius: (scaledRect.size.width/4),
                                  startAngle: CGFloat(M_PI),
                                  endAngle: 0,
                                  clockwise: true)
            
            bezierPath.addCurve(to: CGPoint(x: originalRect.size.width/2, y: scaledRect.origin.y + scaledRect.size.height),
                                 controlPoint1: CGPoint(x: scaledRect.origin.x + scaledRect.size.width, y: scaledRect.origin.y + (scaledRect.size.height/2)),
                                 controlPoint2: CGPoint(x: scaledRect.origin.x + (scaledRect.size.width/2), y: scaledRect.origin.y + (scaledRect.size.height*3/4)) )
            bezierPath.close()
            return bezierPath
        }
    
    
    func interpolatePointsWithHermite(_ interpolationPoints : [CGPoint]) {
        let n = interpolationPoints.count - 1
        
        for i in 0..<n {
            
            var currentPoint = interpolationPoints[i]
            
            if i == 0 { self.move(to: interpolationPoints[0]) }
            
            var nextii = (i + 1) % interpolationPoints.count
            var previi = (i - 1 < 0 ? interpolationPoints.count - 1 : i-1);
            var previousPoint = interpolationPoints[previi]
            var nextPoint = interpolationPoints[nextii]
            let endPoint = nextPoint;
            var mx : Double = 0.0
            var my : Double = 0.0
            
            if i > 0
            {
                mx = Double(nextPoint.x - currentPoint.x) * 0.5 + Double(currentPoint.x - previousPoint.x) * 0.5;
                my = Double(nextPoint.y - currentPoint.y) * 0.5 + Double(currentPoint.y - previousPoint.y) * 0.5;
            }
            else
            {
                mx = Double(nextPoint.x - currentPoint.x) * 0.5;
                my = Double(nextPoint.y - currentPoint.y) * 0.5;
            }
            
            let controlPoint1 = CGPoint(x: Double(currentPoint.x) + mx / 3.0, y: Double(currentPoint.y) + my / 3.0)
            currentPoint = interpolationPoints[nextii]
            nextii = (nextii + 1) % interpolationPoints.count
            previi = i;
            previousPoint = interpolationPoints[previi]
            nextPoint = interpolationPoints[nextii]
            
            if i < n - 1
            {
                mx = Double(nextPoint.x - currentPoint.x) * 0.5 + Double(currentPoint.x - previousPoint.x) * 0.5;
                my = Double(nextPoint.y - currentPoint.y) * 0.5 + Double(currentPoint.y - previousPoint.y) * 0.5;
            }
            else
            {
                mx = Double(currentPoint.x - previousPoint.x) * 0.5;
                my = Double(currentPoint.y - previousPoint.y) * 0.5;
            }
            
            let controlPoint2 = CGPoint(x: Double(currentPoint.x) - mx / 3.0, y: Double(currentPoint.y) - my / 3.0)
            
            self.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
    }
    
}
