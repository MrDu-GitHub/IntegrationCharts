//
//  LineScatterCandleRadarRenderer.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

@objc(LineScatterCandleRadarChartRenderer)
open class LineScatterCandleRadarRenderer: BarLineScatterCandleBubbleRenderer
{
    public override init(animator: Animator, viewPortHandler: ViewPortHandler)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
    }
    
    /// Draws vertical & horizontal highlight-lines if enabled.
    /// :param: context
    /// :param: points
    /// :param: horizontal
    /// :param: vertical
    @objc open func drawHighlightLines(context: CGContext, point: CGPoint, set: ILineScatterCandleRadarChartDataSet)
    {
        
        // draw vertical highlight lines
        if set.isVerticalHighlightIndicatorEnabled
        {
            context.beginPath()
            // 文修2019年08月15日17:55:58
//            context.move(to: CGPoint(x: point.x, y: viewPortHandler.contentTop))
//            context.addLine(to: CGPoint(x: point.x, y: viewPortHandler.contentBottom))
            context.move(to: CGPoint(x: point.x, y: viewPortHandler.contentBottom))
            context.addLine(to: CGPoint(x: point.x, y: point.y))
            context.strokePath()
        }
        
        // draw horizontal highlight lines
        if set.isHorizontalHighlightIndicatorEnabled
        {
            context.beginPath()
            // 文修2019年08月15日17:55:58
//            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: point.y))
//            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: point.y))
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: point.y))
            context.addLine(to: CGPoint(x: point.x, y: point.y))
            context.strokePath()
        }
    }
}
