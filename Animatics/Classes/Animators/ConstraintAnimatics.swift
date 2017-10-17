//
//  ConstraintAnimatics.swift
//  BlackStar
//
//  Created by Nikita Arkhipov on 25.11.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation
import UIKit

public class ConstraintAnimator: AnimationSettingsHolder, AnimaticsViewChangesPerformer {
    public typealias TargetType = NSLayoutConstraint
    public typealias ValueType = CGFloat
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _updateForTarget(_ t: TargetType){
        t.constant = value
        (t.firstItem as? UIView)?.layoutIfNeeded()
        (t.secondItem as? UIView)?.layoutIfNeeded()
    }
    
    public func _cancelAnimation(_ t: TargetType, shouldShowFinalState: Bool) {
        (t.firstItem as? UIView)?.layer.removeAllAnimations()
        (t.secondItem as? UIView)?.layer.removeAllAnimations()
        if shouldShowFinalState { _updateForTarget(t) }
    }
    
    public func _currentValue(_ target: TargetType) -> ValueType { return target.constant }
    
}
