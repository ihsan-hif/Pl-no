//
//  HelperExtension.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 28/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import Foundation
import UIKit

var associateObjectValue: Int = 0

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIButton {
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0,y: 0.0,width: 1.0,height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
    
}

extension UIView: CAAnimationDelegate {
    
    /**
     Adds a vertical gradient layer with two **UIColors** to the **UIView**.
     - Parameter topColor: The top **UIColor**.
     - Parameter bottomColor: The bottom **UIColor**.
     */
    
    func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    fileprivate var isAnimate: Bool {
        get {
            return objc_getAssociatedObject(self, &associateObjectValue) as? Bool ?? false
        }
        set {
            return objc_setAssociatedObject(self, &associateObjectValue, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable var shimmerAnimation: Bool {
        get {
            return isAnimate
        }
        set {
            self.isAnimate = newValue
        }
    }
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
    
    //Circle Fill Animation
    private func getDiagonal() -> CGFloat {
        let origin = self.frame.origin
        let opposite = CGPoint(x: origin.x + self.frame.width,
                               y: origin.y + self.frame.height)
        
        let distanceX = origin.x - opposite.x
        let distanceY = origin.y - opposite.y
        let diagonal = sqrt(pow(distanceX, 2) + pow(distanceY, 2))
        return diagonal
    }
    
    /* FILL BACKGROUND */
    func fillBackgroundFrom(point: CGPoint, with color: UIColor, in time: CFTimeInterval = 1.0) {
        let initialDiameter: CGFloat = 0.5
        let diagonal = getDiagonal()
        let fullViewValue = (diagonal / initialDiameter) * 2
        
        // Create layer
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: initialDiameter,
                             height: initialDiameter)
        layer.position = point
        layer.cornerRadius = initialDiameter / 2
        layer.backgroundColor = color.cgColor
        layer.name = "color"
        
        // Create animation
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = fullViewValue
        animation.duration = time
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        animation.setValue("fill", forKey: "name")
        
        // Add animation to layer and layer to view
        layer.add(animation, forKey: "fillAnimation")
        self.layer.insertSublayer(layer, at: 0)
        //self.layer.addSublayer(layer)
        self.layer.masksToBounds = true
    }
    
    /* EMPTY BACKGROUND */
    func emptyBackgroundTo(point: CGPoint, with color: UIColor, in time: CFTimeInterval = 1.0) {
        guard let subLayers = self.layer.sublayers else {
            return
        }
        
        for subLayer in subLayers {
            if subLayer.name == "color" {
                guard let presentationLayer = subLayer.presentation(),
                let value = presentationLayer.value(forKeyPath: "transform.scale") else {
                    return
                }
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.fromValue = value
                animation.toValue = 1.0
                animation.duration = time
                animation.delegate = self
                animation.setValue("empty", forKey: "name")
                subLayer.add(animation, forKey: "fillAnimation")
            }
        }
    }
}

struct GlobalVariables {
    static let blue = UIColor.rbg(r: 129, g: 144, b: 255)
    static let purple = UIColor.rbg(r: 161, g: 114, b: 255)
}

//Extensions
extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}

extension UITextField {
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.init(red: 133/255, green: 170/255, blue: 209/255, alpha: 0.61).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension String{
    var date : Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.date(from: self)
    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFill else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}

private extension DateComponents {
  func scaled(by: Int) -> DateComponents {
    let s: (Int?)->Int? = { $0.map { $0 * by } }
    return DateComponents(calendar: calendar,
                          timeZone: timeZone,
                          era: s(era),
                          year: s(year), month: s(month), day: s(day),
                          hour: s(hour), minute: s(minute), second: s(second), nanosecond: s(nanosecond),
                          weekday: s(weekday), weekdayOrdinal: s(weekdayOrdinal), quarter: s(quarter),
                          weekOfMonth: s(weekOfMonth), weekOfYear: s(weekOfYear), yearForWeekOfYear: s(yearForWeekOfYear))
    }
}

extension Calendar {

  func makeIterator(components: DateComponents, from date: Date, until: Date?) -> Calendar.DateComponentsIterator {
    return DateComponentsIterator(calendar: self, startDate: date, cutoff: until, components: components, count: 0)
  }

  func makeIterator(every component: Component, stride: Int = 1, from date: Date, until: Date?) -> Calendar.DateComponentsIterator {
    var components = DateComponents(); components.setValue(stride, for: component)
    return makeIterator(components: components, from: date, until: until)
  }

  struct DateComponentsIterator: IteratorProtocol {
    let calendar: Calendar
    let startDate: Date
    let cutoff: Date?
    let components: DateComponents
    var count: Optional<Int> = 0

    mutating func next() -> Date? {
      guard let count = self.count else { return nil } // Ended.
      guard let nextDate = calendar.date(byAdding: components.scaled(by: count), to: startDate) else {
        self.count = nil; return nil
      }
      if let cutoff = self.cutoff, nextDate > cutoff {
        self.count = nil; return nil
      }
      self.count = count + 1
      return nextDate
    }
  }
}


class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class CircleView : UIView {
    var color = UIColor.blue {
        didSet {
            layer.backgroundColor = color.cgColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // Setup the view, by setting a mask and setting the initial color
    private func setup(){
        layer.mask = shape
        layer.backgroundColor = color.cgColor
    }

    // Change the path in case our view changes it's size
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = CGMutablePath()
        // add an elipse, or what ever path/shapes you want
        path.addEllipse(in: bounds)
        // Created an inverted path to use as a mask on the view's layer
        shape.path = UIBezierPath(cgPath: path).reversing().cgPath
    }
    // this is our shape
    private var shape = CAShapeLayer()
}

class IndicatorView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}

//Enums
enum ViewControllerType {
    case welcome
    case home
}

enum PhotoSource {
    case library
    case camera
}

enum ShowExtraView {
    case contacts
    case profile
    case preview
    case map
}

enum MessageType {
    case photo
    case text
    case location
}

enum MessageOwner {
    case sender
    case receiver
}

enum ColorCompatibility {
    static var myOlderiOSCompatibleColorName: UIColor {
        if UIViewController().isDarkMode {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            //return UIColor(hexString: "#F3F3F3", alpha: 0.85)
            return UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        }
    }
}

enum ActionDescriptor {
    case read, unread, more, flag, trash, done, undone
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .read: return "Read"
        case .unread: return "Unread"
        case .more: return "More"
        case .flag: return "Flag"
        case .trash: return "Delete"
        case .done: return "Done"
        case .undone: return "Undone"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .read: name = "Read"
        case .unread: name = "Unread"
        case .more: name = "More"
        case .flag: name = "Flag"
        case .trash: name = "Delete"
        case .done: name = "Done"
        case .undone: name = "Undone"
        }
        
    #if canImport(Combine)
        if #available(iOS 13.0, *) {
            let name: String
            switch self {
            case .read: name = "envelope.open.fill"
            case .unread: name = "envelope.badge.fill"
            case .more: name = "ellipsis.circle.fill"
            case .flag: name = "flag.fill"
            case .trash: name = "trash.fill"
            case .done: name = "checkmark.circle.fill"
            case .undone: name = "checkmark.circle"
            }
            
            if style == .backgroundColor {
                let config = UIImage.SymbolConfiguration(pointSize: 23.0, weight: .regular)
                return UIImage(systemName: name, withConfiguration: config)
            } else {
                let config = UIImage.SymbolConfiguration(pointSize: 22.0, weight: .regular)
                let image = UIImage(systemName: name, withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysTemplate)
                return circularIcon(with: color(forStyle: style), size: CGSize(width: 50, height: 50), icon: image)
            }
        } else {
            return UIImage(named: style == .backgroundColor ? name : name + "-circle")
        }
    #else
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    #endif
    }
    
    func color(forStyle style: ButtonStyle) -> UIColor {
    #if canImport(Combine)
        switch self {
        case .read, .unread, .done, .undone: return UIColor.systemBlue
        case .more:
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    return UIColor.systemGray
                }
                return style == .backgroundColor ? UIColor.systemGray3 : UIColor.systemGray2
            } else {
                return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
            }
        case .flag: return UIColor.systemOrange
        case .trash: return UIColor.systemRed
        }
    #else
        switch self {
        case .read, .unread, .done, .undone: return #colorLiteral(red: 0, green: 0.4577052593, blue: 1, alpha: 1)
        case .more: return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        case .flag: return #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        case .trash: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
    #endif
    }
    
    func circularIcon(with color: UIColor, size: CGSize, icon: UIImage? = nil) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        UIBezierPath(ovalIn: rect).addClip()

        color.setFill()
        UIRectFill(rect)

        if let icon = icon {
            let iconRect = CGRect(x: (rect.size.width - icon.size.width) / 2,
                                  y: (rect.size.height - icon.size.height) / 2,
                                  width: icon.size.width,
                                  height: icon.size.height)
            icon.draw(in: iconRect, blendMode: .normal, alpha: 1.0)
        }

        defer { UIGraphicsEndImageContext() }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}
