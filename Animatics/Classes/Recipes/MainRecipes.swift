//
//  MainRecipes.swift
//  ForestLand
//
//  Created by Nikita Arkhipov on 21.12.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation
import UIKit

public class ShakeAnimator: AnimationSettingsHolder, Animatics{
    public typealias TargetType = UIView
    public typealias ValueType = Void
    
    let v = 7
    public let value: ValueType
    
    required public init(_ v: ValueType){
        value = v
        super.init()
        _duration = 0.24
    }
    
    public func _animateWithTarget(_ t: TargetType, completion: AnimaticsCompletionBlock?){
        let CGM_PI = CGFloat.pi
        (RotateAnimator(CGM_PI/12).delay(_delay).duration(_duration/4) |->
            RotateAnimator(-CGM_PI/6).duration(_duration/2) |->
            RotateAnimator(0.0).duration(_duration/4)).baseAnimation(.curveLinear).to(t).animateWithCompletion(completion)
    }
    
    public func _performWithoutAnimationToTarget(_ t: TargetType) { }
    
    public func _cancelAnimation(_ t: TargetType, shouldShowFinalState: Bool) { }
    public func _currentValue(_ target: TargetType) -> ValueType { return () }
}

public class ScaleAndBackAnimator: AnimationSettingsHolder, Animatics{
    public typealias TargetType = UIView
    public typealias ValueType = CGFloat
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _animateWithTarget(_ t: TargetType, completion: AnimaticsCompletionBlock?){
        (ScaleAnimator(value).copySettingsFrom(self) |-> TransformAnimator(t.transform).copySettingsFrom(self)).duration(_duration/2).to(t).animateWithCompletion(completion)
    }
    
    public func _performWithoutAnimationToTarget(_ t: TargetType) { }
    
    public func _cancelAnimation(_ t: TargetType, shouldShowFinalState: Bool) {
        t.layer.removeAllAnimations()
    }
    
    public func _currentValue(_ target: TargetType) -> ValueType { return 1 }
    
}
