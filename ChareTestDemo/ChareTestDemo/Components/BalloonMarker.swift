//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import Charts


open class BalloonMarker: MarkerImage
{
    // 身高曲线标准值范围
    lazy var standardArray:[String] = {
        () -> [String] in
        
        return ["3","10","25", "50", "75", "90", "97"]
    }()
    
    // 婴儿标准位年龄
    lazy var babyYear:[String] = {
        () -> [String] in
        
        return ["0","2","4", "6", "9", "12", "15", "18", "21", "24"]
    }()
    
    @objc open var dataType : Int
    @objc open var yearType : Int
    @objc open var color: UIColor
    @objc open var arrowSize = CGSize(width: 15, height: 11)
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()
    @objc open var dataArray = NSArray()
    
    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        self.dataType = 0
        self.yearType = 0
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil
        {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image!.size.height
        }

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x + padding
        }
        else if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width
        {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0
        {
            offset.y = height + padding;
        }
        else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height
        {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()

        context.setFillColor(color.cgColor)

        if offset.y > 0
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.fillPath()
        }
        else
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }
        
        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }

        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        label.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        var monthString = ""
        
        var month = 0
        
        // 2 - 18
        if yearType == 0 {
            month = Int((entry.x * 1.2))
        // 0 - 2
        }else {
            month = Int(entry.x)
        }
        
        if entry.x < 12 {
            monthString = String(format: "%.0f个月", entry.x)
        }else if month%12 > 0 {
            monthString = String(format: "%d岁%d个月", month/12, month%12)
        }else {
            monthString = String(format: "%d岁", month/12)
        }
        
        var unitString = "cm"
        if dataType == 1 {
            unitString = "kg"
        }else {
            unitString = "cm"
        }
        
        let desString = String(format: "%@\n%@%@\nP:%@", monthString, String(entry.y), unitString, setDesString(entry: entry))
        setLabel(String(desString))
    }
    
    @objc open func setLabel(_ newLabel: String)
    {
        label = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
    
    @objc open func setDesString(entry: ChartDataEntry) -> String {
        var yearArray = babyYear
        var year = ""
        let tempArray = dataArray.firstObject as! NSArray
        
        // 确定X标准值
        for yearString in yearArray {
            if (entry.x - Double(yearString)!>0.001) {
                year = yearString
            }else if (entry.x == Double(yearString)) {
                year = yearString
                break
            }else {
                year = yearString
                break
            }
        }
        
        var min = 100
        var max = 100
        var i = 0
        
        // 确定Y标准范围
        for valueArray in dataArray {
            let valueStrArray: NSArray = valueArray as! NSArray
            var value = 0.0
            
            // 当前标准X的位置 指定的Y值
            value = (Double)(valueStrArray[yearArray.index(of: year)!] as! String)!
            
            if (entry.y - value > 0.001) {
                min = i
            }else if (entry.y == value) {
                min = i
                max = i
                break
            }else {
                max = i
                break
            }
            i = i+1
        }
        
        if min == max {
            return NSString(format: "=%@", standardArray[min]) as String
        }else if min == 6 {
            return ">97"
        }else if max == 0 {
            return "<3"
        }
        
        return NSString(format: "%@~%@", standardArray[min], standardArray[max]) as String
    }
}
