//
//  AnimaticsFoundation.swift
//  AnimationFramework
//
//  Created by Nikita Arkhipov on 14.09.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation

public protocol AnimaticsTargetWaiter: AnimaticsSettingsSetter{
    associatedtype TargetType: AnyObject
    func to(_ t: TargetType) -> AnimaticsReady
}

public protocol Animatics: AnimaticsSettingsHolder, AnimaticsTargetWaiter{
    associatedtype ValueType
    
    var value: ValueType { get }
    
    init(_ v: ValueType)
    
    func _animateWithTarget(_ t: TargetType, completion: AnimaticsCompletionBlock?)
    func _performWithoutAnimationToTarget(_ t: TargetType)
    func _cancelAnimation(_ t: TargetType, shouldShowFinalState: Bool)
    func _currentValue(_ target: TargetType) -> ValueType
}

public extension Animatics{
    public func to(_ target: TargetType) -> AnimaticsReady{ return AnimationReady(animator: self, target: target) }
    
    public func animaticsReadyCreator() -> (TargetType) -> AnimaticsReady{ return to }
}

public protocol AnimaticsReady: AnimaticsSettingsSetter {
    func animateWithCompletion(_ completion: AnimaticsCompletionBlock?)
    func performWithoutAnimation()
    func cancelAnimation(_ shouldShowFinalState: Bool)
    func reversedAnimation() -> AnimaticsReady
    func withCompletionBlock(_ block: @escaping AnimaticsEmptyBlock) -> AnimaticsReady
}

public extension AnimaticsReady{
    public func animate(){ animateWithCompletion(nil) }
    public func animateWithCompletion(_ completion: AnimaticsEmptyBlock?){ animateWithCompletion(emptyBlock(completion, type: Bool.self)) }
}

final public class AnimationReady<T: Animatics>: AnimaticsReady, AnimaticsSettingsSettersWrapper {
    let animator: T
    let target: T.TargetType
    let reverseAnimator: T
    
    private var completionBlocks: [AnimaticsEmptyBlock] = []
    
    public init(animator: T, target: T.TargetType){
        self.animator = animator
        self.target = target
        self.reverseAnimator = T(animator._currentValue(target))
    }
    
    public func animateWithCompletion(_ completion: AnimaticsCompletionBlock? = nil){
        animator._animateWithTarget(target, completion: completion)
    }
    
    public func performWithoutAnimation(){
        animator._performWithoutAnimationToTarget(target)
    }
    
    public func cancelAnimation(_ shouldShowFinalState: Bool) {
        animator._cancelAnimation(target, shouldShowFinalState: shouldShowFinalState)
    }
    
    public func reversedAnimation() -> AnimaticsReady {
        return reverseAnimator.copySettingsFrom(animator).to(target)
    }
    
    public func getSettingsSetters() -> [AnimaticsSettingsSetter]{ return [animator] }
    
    public func getDuration() -> TimeInterval {
        return animator.getDuration()
    }
    
    public func withCompletionBlock(_ block: @escaping () -> ()) -> AnimaticsReady {
        completionBlocks.append(block)
        return self
    }
}

precedencegroup LeftAssociatable{
    associativity: left
}

infix operator |-> : LeftAssociatable
infix operator ~>
infix operator ~?>
public func ~><T: AnimaticsTargetWaiter>(a: T, t: T.TargetType){
    a.to(t).animate()
}

public func ~><T: AnimaticsTargetWaiter>(a: T, targets: [T.TargetType]){
    for t in targets{ a.to(t).animate() }
}


public func ~?><T: AnimaticsTargetWaiter>(a: T, t: T.TargetType?){
    if let t = t{ a.to(t).animate() }
}


public func Animatics_GCD_After(_ seconds: Double, block: @escaping () -> ()){
    let delayTime = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        block()
    }
}

public typealias AnimaticsEmptyBlock = () -> ()
public func emptyBlock<T>(_ block: @escaping AnimaticsEmptyBlock, type: T.Type) -> (T) -> (){
    return { _ in block() }
}

public func emptyBlock<T>(_ block: AnimaticsEmptyBlock?, type: T.Type) -> (T) -> (){
    return { _ in block?() }
}


public func fillBlock<T>(_ block: @escaping (T) -> (), value: T) -> AnimaticsEmptyBlock{
    return { block(value) }
}

public func fillBlock<T>(_ block: ((T) -> ())?, value: T) -> AnimaticsEmptyBlock{
    return { block?(value) }
}

