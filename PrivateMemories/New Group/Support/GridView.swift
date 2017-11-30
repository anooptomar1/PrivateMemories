//
//  GridView.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class GridView: UIView {
    let gridWidth: CGFloat = 1.2
    let cornerWidth: CGFloat = 9.0
    let cornerLength: CGFloat = 20.0
    var columns: Int
    
    init(frame: CGRect, columns: Int) {
        self.columns = columns - 1
        super.init(frame: frame)
        self.isOpaque = false
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.0);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(gridWidth)
        context.setStrokeColor(UIColor.white.alpha(0.7).cgColor)
        
        var upperLeftCorner: CGPoint?
        var upperRightCorner: CGPoint?
        var lowerLeftCorner: CGPoint?
        var lowerRightCorner: CGPoint?

        let columnWidth: CGFloat = self.frame.size.width / (CGFloat(self.columns) + 1.0)
        let rowHeight: CGFloat = rect.size.height / (CGFloat(self.columns) + 1.0)
        let numberOfRows: Int = Int(self.frame.size.height)/Int(rowHeight)

        for column in 1...self.columns {
            let startPoint: CGPoint = CGPoint(x: columnWidth * CGFloat(column), y: 0.0)
            let endPoint: CGPoint = CGPoint(x: startPoint.x, y: self.frame.size.height)
            
            context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
            context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
            context.strokePath()
        }
        
        for row in 0...numberOfRows {
            let startPoint: CGPoint = CGPoint(x: 0.0, y: rowHeight * CGFloat(row))
            let endPoint: CGPoint = CGPoint(x: self.frame.size.width, y: startPoint.y)
            
            context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
            context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
            context.strokePath()
            
            if row == 0 {
                upperLeftCorner = startPoint
                upperRightCorner = endPoint
            } else if row == numberOfRows {
                lowerLeftCorner = startPoint
                lowerRightCorner = endPoint
            }
        }
        
        context.setLineWidth(cornerWidth)
        
        context.move(to: upperLeftCorner!)
        context.addLine(to: CGPoint(x: upperLeftCorner!.x + cornerLength, y: upperRightCorner!.y))
        context.strokePath()
        context.move(to: upperLeftCorner!)
        context.addLine(to: CGPoint(x: upperLeftCorner!.x, y: upperRightCorner!.y + cornerLength))
        context.strokePath()
        
        context.move(to: upperRightCorner!)
        context.addLine(to: CGPoint(x: upperRightCorner!.x - cornerLength, y: upperRightCorner!.y))
        context.strokePath()
        context.move(to: upperRightCorner!)
        context.addLine(to: CGPoint(x: upperRightCorner!.x, y: upperRightCorner!.y + cornerLength))
        context.strokePath()
        
        context.move(to: lowerLeftCorner!)
        context.addLine(to: CGPoint(x: lowerLeftCorner!.x + cornerLength, y: lowerRightCorner!.y))
        context.strokePath()
        context.move(to: lowerLeftCorner!)
        context.addLine(to: CGPoint(x: lowerLeftCorner!.x, y: lowerRightCorner!.y - cornerLength))
        context.strokePath()
        
        context.move(to: lowerRightCorner!)
        context.addLine(to: CGPoint(x: lowerRightCorner!.x - cornerLength, y: lowerRightCorner!.y))
        context.strokePath()
        context.move(to: lowerRightCorner!)
        context.addLine(to: CGPoint(x: lowerRightCorner!.x, y: lowerRightCorner!.y - cornerLength))
        context.strokePath()
    }
}
