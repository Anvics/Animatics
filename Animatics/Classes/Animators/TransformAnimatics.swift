//
//  TransformAnimatics.swift
//  PokeScrum
//
//  Created by Nikita Arkhipov on 19.09.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation
import UIKit

public class IdentityTransformAnimator: AnimationSettingsHolder, AnimaticsViewChangesPerformer {
    public typealias TargetType = UIView
    public typealias ValueType = ()
    var a: Int = 7
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    public func _updateForTarget(_ t: TargetType){ t.transform = CGAffineTransform.identity }
    public func _currentValue(_ target: TargetType) -> ValueType { return () }
}

public class ViewTransformAnimatics: AnimationSettingsHolder, AnimaticsViewChangesPerformer {
    public typealias TargetType = UIView
    public typealias ValueType = CGAffineTransform
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _updateForTarget(_ t: TargetType){ fatalError() }
    public func _currentValue(_ target: TargetType) -> ValueType { return target.transform }
}

public class TransformAnimator: ViewTransformAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.transform = value }
}

public class AdditiveTransformAnimator: ViewTransformAnimatics {
    override public func _updateForTarget(_ t: TargetType) { t.transform = t.transform.concatenating(value) }
}

public class ScaleAnimator: ViewFloatAnimatics {
    override public func _updateForTarget(_ t: TargetType) { t.transform = CGAffineTransform(scaleX: value, y: value) }
    override public func _currentValue(_ target: TargetType) -> ValueType {
        let t = target.transform
        return sqrt(t.a*t.a + t.c*t.c)
    }
}

public class ScaleXYAnimator: AnimationSettingsHolder, AnimaticsViewChangesPerformer{
    public typealias TargetType = UIView
    public typealias ValueType = (CGFloat, CGFloat)
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    public func _updateForTarget(_ t: TargetType){ t.transform = CGAffineTransform(scaleX: value.0, y: value.1) }
    public func _currentValue(_ target: TargetType) -> ValueType {
        let t = target.transform
        let sx = sqrt(t.a*t.a + t.c*t.c)
        let sy = sqrt(t.b*t.b + t.d*t.d)
        return (sx, sy)
    }
}

public class AdditiveScaleAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.transform = t.transform.concatenating(CGAffineTransform(scaleX: value, y: value)) }
    override public func _currentValue(_ target: TargetType) -> ValueType {
        let t = target.transform
        return sqrt(t.a*t.a + t.c*t.c)
    }
}

public class RotateAnimator: ViewFloatAnimatics {
    convenience public init(_ v: Double) { self.init(CGFloat(v)) }
    override public func _updateForTarget(_ t: TargetType) { t.transform = CGAffineTransform(rotationAngle: value) }
    override public func _currentValue(_ target: TargetType) -> ValueType { return atan2(target.transform.b, target.transform.a) }
}

public class AdditiveRotateAnimator: ViewFloatAnimatics {
    convenience public init(_ v: Double) { self.init(CGFloat(v)) }
    override public func _updateForTarget(_ t: TargetType) { t.transform = t.transform.concatenating(CGAffineTransform(rotationAngle: value)) }
    override public func _currentValue(_ target: TargetType) -> ValueType { return atan2(target.transform.b, target.transform.a) }
}

public class XTranslateAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.transform = CGAffineTransform(translationX: value, y: 0) }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.transform.tx }
}

public class YTranslateAnimator: ViewFloatAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.transform = CGAffineTransform(translationX: 0, y: value) }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.transform.ty }
}

public class TranslateAnimator: ViewPointAnimatics{
    override public func _updateForTarget(_ t: TargetType) { t.transform = CGAffineTransform(translationX: value.x, y: value.y) }
    override public func _currentValue(_ target: TargetType) -> ValueType { return CGPoint(x: target.transform.tx, y: target.transform.ty) }
}
