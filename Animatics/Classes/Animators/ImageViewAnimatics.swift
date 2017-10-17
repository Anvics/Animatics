//
//  ImageViewAnimatics.swift
//  AnimationFramework
//
//  Created by Nikita Arkhipov on 14.09.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation
import UIKit

public class ImageAnimator: AnimationSettingsHolder, Animatics {
    public typealias TargetType = UIImageView
    public typealias ValueType = UIImage?
    
    public let value: ValueType
    
    required public init(_ v: ValueType){
        value = v
        super.init()
        _animationOptions = .transitionCrossDissolve
    }
    
    public func _animateWithTarget(_ t: TargetType, completion: AnimaticsCompletionBlock?){
        Animatics_GCD_After(_delay) {
            UIView.transition(with: t, duration: self._duration, options: self._animationOptions, animations: { () -> Void in
                t.image = self.value
            }, completion: completion)
        }
    }
    
    public func _performWithoutAnimationToTarget(_ t: TargetType) {
        t.image = value
    }
    
    public func _cancelAnimation(_ t: TargetType, shouldShowFinalState: Bool) {
        t.layer.removeAllAnimations()
        t.image = value
    }
    
    public func _currentValue(_ target: TargetType) -> ValueType { return target.image }
}

public class ImageTintAnimator: AnimationSettingsHolder, AnimaticsViewChangesPerformer{
    public typealias TargetType = UIImageView
    public typealias ValueType = UIColor
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _updateForTarget(_ t: TargetType){ t.tintColor = value }
    public func _currentValue(_ target: TargetType) -> ValueType { return target.tintColor }
}

