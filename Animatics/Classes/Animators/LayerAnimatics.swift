//
//  LayerAnimatics.swift
//  PokeScrum
//
//  Created by Nikita Arkhipov on 19.09.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation
import UIKit

public class LayerFloatAnimatics: AnimationSettingsHolder, AnimaticsLayerChangesPerformer {
    public typealias TargetType = UIView
    public typealias ValueType = CGFloat
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _animationKeyPath() -> String { fatalError("_animationKeyPath() is called but not implemented in \(type(of: self))") }
}

public class ShadowRadiusAnimator: LayerFloatAnimatics {
    override public func _animationKeyPath() -> String { return "shadowRadius" }
}

public class ShadowOpacityAnimator: LayerFloatAnimatics {
    override public func _animationKeyPath() -> String { return "shadowOpacity" }
}

public class CornerRadiusAnimator: LayerFloatAnimatics {
    override public func _animationKeyPath() -> String { return "cornerRadius" }
}

public class BorderWidthAnimator: LayerFloatAnimatics {
    override public func _animationKeyPath() -> String { return "borderWidth" }
}

public class LayerTransformAnimatics: AnimationSettingsHolder, AnimaticsLayerChangesPerformer {
    public typealias TargetType = UIView
    public typealias ValueType = CATransform3D
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _animationKeyPath() -> String { return "transform" }
}

public class LayerColorAnimatics: AnimationSettingsHolder, AnimaticsLayerChangesPerformer {
    public typealias TargetType = UIView
    public typealias ValueType = CGColor
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    public init(_ v: UIColor) { value = v.cgColor }
    
    public func _animationKeyPath() -> String { fatalError("_animationKeyPath() is called but not implemented in \(type(of: self))") }
}

public class BorderColorAnimator: LayerColorAnimatics {
    override public func _animationKeyPath() -> String { return "borderColor" }
}

public class GradientLayerPointAnimatics: AnimationSettingsHolder, AnimaticsLayerChangesPerformer {
    public typealias TargetType = CAGradientLayer
    public typealias ValueType = CGPoint
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _animationKeyPath() -> String { fatalError("_animationKeyPath() is called but not implemented in \(type(of: self))") }
}

public class GradientLayerStartPointAnimator: GradientLayerPointAnimatics {
    override public func _animationKeyPath() -> String { return "startPoint" }
}

public class GradientLayerEndPointAnimator: GradientLayerPointAnimatics {
    override public func _animationKeyPath() -> String { return "endPoint" }
}
