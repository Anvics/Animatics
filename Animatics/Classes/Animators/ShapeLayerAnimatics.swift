//
//  ShapeLayerAnimatics.swift
//  Animatics
//
//  Created by Nikita Arkhipov on 24.10.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation
import UIKit

public class ShapeLayerFloatAnimatics: AnimationSettingsHolder, AnimaticsLayerChangesPerformer {
    public typealias TargetType = CAShapeLayer
    public typealias ValueType = CGFloat
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _animationKeyPath() -> String { fatalError("_animationKeyPath() is called but not implemented in \(type(of: self))") }
}

public class StrokeStartAnimator: ShapeLayerFloatAnimatics{
    override public func _animationKeyPath() -> String { return "strokeStart" }
}

public class StrokeEndAnimator: ShapeLayerFloatAnimatics{
    override public func _animationKeyPath() -> String { return "strokeEnd" }
}

public class LineWidthAnimator: ShapeLayerFloatAnimatics{
    override public func _animationKeyPath() -> String { return "lineWidth" }
}

public class MitterLimitAnimator: ShapeLayerFloatAnimatics{
    override public func _animationKeyPath() -> String { return "miterLimit" }
}

public class LineDashPhaseAnimator: ShapeLayerFloatAnimatics{
    override public func _animationKeyPath() -> String { return "lineDashPhase" }
}


public class ShapeLayerColorAnimatics: AnimationSettingsHolder, AnimaticsLayerChangesPerformer {
    public typealias TargetType = CAShapeLayer
    public typealias ValueType = UIColor
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _animationKeyPath() -> String { fatalError("_animationKeyPath() is called but not implemented in \(type(of: self))") }
    public func _newValue() -> AnyObject { return value.cgColor as AnyObject }
}

public class FillColorAnimator: ShapeLayerColorAnimatics{
    override public func _animationKeyPath() -> String { return "fillColor" }
}

public class StrokeColorAnimator: ShapeLayerColorAnimatics{
    override public func _animationKeyPath() -> String { return "strokeColor" }
}


public class PathAnimator: AnimationSettingsHolder, AnimaticsLayerChangesPerformer{
    public typealias TargetType = CAShapeLayer
    public typealias ValueType = CGPath
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _animationKeyPath() -> String { return "path" }
}
