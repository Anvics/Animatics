//
//  ViewFloatAnimatics.swift
//  AnimationFramework
//
//  Created by Nikita Arkhipov on 14.09.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation
import UIKit

public class ViewFloatAnimatics: AnimationSettingsHolder, AnimaticsViewChangesPerformer {
    public typealias TargetType = UIView
    public typealias ValueType = CGFloat
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _updateForTarget(_ t: TargetType){ fatalError() }
    public func _currentValue(_ target: TargetType) -> ValueType{ fatalError() }
}

public class XAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.frame.origin.x = value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.origin.x }
}

public class DXAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.frame.origin.x += value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.origin.x }
}

public class YAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.frame.origin.y = value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.origin.y }
}

public class DYAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.frame.origin.y += value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.origin.y }
}

public class WidthAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.frame.size.width = value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.size.width }
}

public class DWidthAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.frame.size.width += value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.size.width }
}

public class HeightAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.frame.size.height = value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.size.height }
}

public class DHeightAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.frame.size.height += value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.size.height }
}

public class AlphaAnimator: ViewFloatAnimatics {
    override public func _updateForTarget(_ t: TargetType) { t.alpha = value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.alpha }
}


public class ViewPointAnimatics: AnimationSettingsHolder, AnimaticsViewChangesPerformer {
    public typealias TargetType = UIView
    public typealias ValueType = CGPoint
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _updateForTarget(_ t: TargetType){ fatalError() }
    public func _currentValue(_ target: TargetType) -> ValueType{ fatalError() }
}

public class OriginAnimator: ViewPointAnimatics {
    override public func _updateForTarget(_ t: TargetType) { t.frame.origin = value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.origin }
}

public class DOriginAnimator: ViewPointAnimatics {
    override public func _updateForTarget(_ t: TargetType) { t.frame.origin.x += value.x; t.frame.origin.y += value.y }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.origin }
}

public class CenterAnimator: ViewPointAnimatics {
    override public func _updateForTarget(_ t: TargetType) { t.center = value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.center }
}

public class SizeAnimator: AnimationSettingsHolder, AnimaticsViewChangesPerformer {
    public typealias TargetType = UIView
    public typealias ValueType = CGSize
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _updateForTarget(_ t: TargetType){ t.frame.size = value }
    public func _currentValue(_ target: TargetType) -> ValueType { return target.frame.size }
}

public class FrameAnimator: AnimationSettingsHolder, AnimaticsViewChangesPerformer {
    public typealias TargetType = UIView
    public typealias ValueType = CGRect
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _updateForTarget(_ t: TargetType){ t.frame = value }
    public func _currentValue(_ target: TargetType) -> ValueType { return target.frame }
}
