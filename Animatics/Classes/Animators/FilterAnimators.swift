//
//  FilterAnimators.swift
//  Animatics
//
//  Created by Nikita Arkhipov on 02.11.16.
//  Copyright © 2016 Anvics. All rights reserved.
//

import UIKit

public class FilterAnimator: AnimationSettingsHolder, Animatics {
    public typealias TargetType = UIImageView
    public typealias ValueType = Filter.Applyer
    
    public let value: ValueType
    
    fileprivate var tmpImageView: UIImageView!
    
    required public init(_ v: @escaping ValueType){ value = v }
    
    public func _animateWithTarget(_ t: TargetType, completion: AnimaticsCompletionBlock?){
        guard let image = t.image,
            let ciimage = CIImage(image: image) else{
                return
        }
        tmpImageView = UIImageView(image: image)
        tmpImageView.frame = t.bounds
        t.addSubview(tmpImageView)
        
        t.image = UIImage(ciImage: value(ciimage))
        AlphaAnimator(0).copySettingsFrom(self).to(tmpImageView).animateWithCompletion { (completed: Bool) -> Void in
            self.tmpImageView.removeFromSuperview()
            completion?(completed)
        }
    }
    
    public func _performWithoutAnimationToTarget(_ t: TargetType) {
        guard let image = t.image,
            let ciimage = CIImage(image: image) else{
                return
        }
        t.image = UIImage(ciImage: value(ciimage))
    }
    
    public func _cancelAnimation(_ t: TargetType, shouldShowFinalState: Bool) {
        tmpImageView?.removeFromSuperview()
    }
    
    public func _currentValue(_ target: TargetType) -> ValueType { return value }
}

public class FilterAndBackAnimator: AnimationSettingsHolder, Animatics {
    public typealias TargetType = UIImageView
    public typealias ValueType = Filter.Applyer
    
    public let value: ValueType
    
    fileprivate var tmpImageView: UIImageView!
    
    required public init(_ v: @escaping ValueType){ value = v }
    
    public func _animateWithTarget(_ t: TargetType, completion: AnimaticsCompletionBlock?){
        guard let image = t.image,
            let ciimage = CIImage(image: image) else{
                return
        }
        tmpImageView = UIImageView(image: UIImage(ciImage: value(ciimage)))
        tmpImageView.frame = t.bounds
        tmpImageView.alpha = 0
        t.addSubview(tmpImageView)
        
        let animation = (AlphaAnimator(1).copySettingsFrom(self) |-> AlphaAnimator(1).copySettingsFrom(self)).duration(_duration/2)
        animation.to(tmpImageView).animateWithCompletion { (completed: Bool) -> Void in
            self.tmpImageView.removeFromSuperview()
            completion?(completed)
        }
    }
    
    public func _performWithoutAnimationToTarget(_ t: TargetType) {}
    
    public func _cancelAnimation(_ t: TargetType, shouldShowFinalState: Bool) {
        tmpImageView?.removeFromSuperview()
    }
    
    public func _currentValue(_ target: TargetType) -> ValueType { return value }
}
