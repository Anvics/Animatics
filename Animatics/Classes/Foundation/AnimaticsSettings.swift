//
//  AnimaticsSettings.swift
//  PokeScrum
//
//  Created by Nikita Arkhipov on 14.10.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation
import UIKit

public typealias AnimaticsCompletionBlock = (Bool) -> Void

public protocol AnimaticsSettingsSetter{
    func duration(_ d: TimeInterval) -> Self
    func delay(_ d: TimeInterval) -> Self
    func baseAnimation(_ o: UIView.AnimationOptions) -> Self
    func springAnimation(_ dumping: CGFloat, velocity: CGFloat) -> Self
    
    func getDuration() -> TimeInterval
}

public protocol AnimaticsSettingsHolder: AnimaticsSettingsSetter{
    var _duration: TimeInterval { get set }
    var _delay: TimeInterval  { get set }
    var _animationOptions: UIView.AnimationOptions { get set }
    var _isSpring: Bool { get set }
    var _springDumping: CGFloat { get set }
    var _springVelocity: CGFloat { get set }
    var _completion: AnimaticsCompletionBlock? { get set }
    func copySettingsFrom(_ source: AnimaticsSettingsHolder) -> Self
}

public class AnimationSettingsHolder: AnimaticsSettingsHolder{
    public var _duration: TimeInterval = 0.35
    public var _delay: TimeInterval = 0
    public var _animationOptions: UIView.AnimationOptions = UIView.AnimationOptions()
    public var _isSpring: Bool = true
    public var _springDumping: CGFloat = 0.8
    public var _springVelocity: CGFloat = 0
    public var _completion: AnimaticsCompletionBlock? = nil
    
    public func duration(_ d: TimeInterval) -> Self{
        _duration = d
        return self
    }
    
    public func delay(_ d: TimeInterval) -> Self{
        _delay = d
        return self
    }
    
    public func baseAnimation(_ o: UIView.AnimationOptions = UIView.AnimationOptions()) -> Self{
        _isSpring = false
        _animationOptions = o
        return self
    }
    
    public func springAnimation(_ dumping: CGFloat = 0.8, velocity: CGFloat = 0) -> Self{
        _isSpring = true
        _springDumping = dumping
        _springVelocity = velocity
        return self
    }
    
    public func copySettingsFrom(_ source: AnimaticsSettingsHolder) -> Self{
        _duration = source._duration
        _delay = source._delay
        _animationOptions = source._animationOptions
        _isSpring = source._isSpring
        _springDumping = source._springDumping
        _springVelocity = source._springVelocity
        return self
    }
    
    public func getDuration() -> TimeInterval { return _duration }
}

public protocol AnimaticsSettingsSettersWrapper: AnimaticsSettingsSetter {
    func getSettingsSetters() -> [AnimaticsSettingsSetter]
}

public extension AnimaticsSettingsSettersWrapper{
    public func duration(_ d: TimeInterval) -> Self{
        for s in getSettingsSetters(){ _ = s.duration(d) }
        return self
    }
    
    public func delay(_ d: TimeInterval) -> Self{
        for s in getSettingsSetters(){ _ = s.delay(d) }
        return self
        
    }
    public func baseAnimation(_ o: UIView.AnimationOptions = UIView.AnimationOptions.curveEaseInOut) -> Self{
        for s in getSettingsSetters(){ _ = s.baseAnimation(o) }
        return self
    }
    
    public func springAnimation(_ dumping: CGFloat = 0.8, velocity: CGFloat = 0) -> Self{
        for s in getSettingsSetters(){ _ = s.springAnimation(dumping, velocity: velocity) }
        return self
    }
}
