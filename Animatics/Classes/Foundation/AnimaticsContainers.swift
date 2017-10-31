//
//  AnimationReady.swift
//  PokeScrum
//
//  Created by Nikita Arkhipov on 20.09.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation

final public class SimultaneousAnimations: AnimaticsReady, AnimaticsSettingsSettersWrapper{
    fileprivate let firstAnimator: AnimaticsReady
    fileprivate let secondAnimator: AnimaticsReady
    private var completionBlocks: [AnimaticsEmptyBlock] = []

    public init(firstAnimator: AnimaticsReady, secondAnimator: AnimaticsReady){
        self.firstAnimator = firstAnimator
        self.secondAnimator = secondAnimator
    }
    
    public func animateWithCompletion(_ completion: AnimaticsCompletionBlock?) {
        var animationsLeft = 2
        for animator in [firstAnimator, secondAnimator]{
            animator.animateWithCompletion { _ in
                animationsLeft -= 1
                if animationsLeft == 0 { completion?(true) }
            }
        }
    }
    
    public func performWithoutAnimation() {
        firstAnimator.performWithoutAnimation()
        secondAnimator.performWithoutAnimation()
    }
    
    public func cancelAnimation(_ shouldShowFinalState: Bool) {
        firstAnimator.cancelAnimation(shouldShowFinalState)
        secondAnimator.cancelAnimation(shouldShowFinalState)
    }
    
    public func reversedAnimation() -> AnimaticsReady{
        return firstAnimator.reversedAnimation() + secondAnimator.reversedAnimation()
    }
    
    public func getSettingsSetters() -> [AnimaticsSettingsSetter] { return [firstAnimator, secondAnimator] }
    
    public func getDuration() -> TimeInterval {
        return max(firstAnimator.getDuration(), secondAnimator.getDuration())
    }
    
    public func withCompletionBlock(_ block: @escaping () -> ()) -> AnimaticsReady {
        completionBlocks.append(block)
        return self
    }
}

final public class SequentialAnimations: AnimaticsReady, AnimaticsSettingsSettersWrapper{
    fileprivate let firstAnimator: AnimaticsReady
    fileprivate let secondAnimator: AnimaticsReady
    private var completionBlocks: [AnimaticsEmptyBlock] = []

    public init(firstAnimator: AnimaticsReady, secondAnimator: AnimaticsReady){
        self.firstAnimator = firstAnimator
        self.secondAnimator = secondAnimator
    }
    
    public func animateWithCompletion(_ completion: AnimaticsCompletionBlock?) {
        firstAnimator.animateWithCompletion { _ in
            self.secondAnimator.animateWithCompletion(completion)
        }
    }
    
    public func performWithoutAnimation() {
        firstAnimator.performWithoutAnimation()
        secondAnimator.performWithoutAnimation()
    }
    
    public func cancelAnimation(_ shouldShowFinalState: Bool) {
        firstAnimator.cancelAnimation(shouldShowFinalState)
        secondAnimator.cancelAnimation(shouldShowFinalState)
    }
    
    public func reversedAnimation() -> AnimaticsReady{
        return secondAnimator.reversedAnimation() |-> firstAnimator.reversedAnimation()
    }
    
    public func getSettingsSetters() -> [AnimaticsSettingsSetter] { return [firstAnimator, secondAnimator] }
    
    public func getDuration() -> TimeInterval {
        return firstAnimator.getDuration() + secondAnimator.getDuration()
    }
    
    public func withCompletionBlock(_ block: @escaping () -> ()) -> AnimaticsReady {
        completionBlocks.append(block)
        return self
    }
}

final public class SimultaneousAnimationsTargetWaiter<T: AnimaticsTargetWaiter, U: AnimaticsTargetWaiter>: AnimaticsTargetWaiter, AnimaticsSettingsSettersWrapper where T.TargetType == U.TargetType{
    public  typealias TargetType = T.TargetType
    
    fileprivate let firstAnimator: T
    fileprivate let secondAnimator: U
    
    public init(firstAnimator: T, secondAnimator: U){
        self.firstAnimator = firstAnimator
        self.secondAnimator = secondAnimator
    }
    
    public func getSettingsSetters() -> [AnimaticsSettingsSetter] { return [firstAnimator, secondAnimator] }
    
    public func to(_ t: TargetType) -> AnimaticsReady{
        return SimultaneousAnimations(firstAnimator: firstAnimator.to(t), secondAnimator: secondAnimator.to(t))
    }
    
    public func getDuration() -> TimeInterval {
        return max(firstAnimator.getDuration(), secondAnimator.getDuration())
    }
}

final public class SequentialAnimationsTargetWaiter<T: AnimaticsTargetWaiter, U: AnimaticsTargetWaiter>: AnimaticsTargetWaiter, AnimaticsSettingsSettersWrapper where T.TargetType == U.TargetType{
    public  typealias TargetType = T.TargetType
    
    fileprivate let firstAnimator: T
    fileprivate let secondAnimator: U
    
    public init(firstAnimator: T, secondAnimator: U){
        self.firstAnimator = firstAnimator
        self.secondAnimator = secondAnimator //никитос красавчик
    }
    
    public func getSettingsSetters() -> [AnimaticsSettingsSetter] { return [firstAnimator, secondAnimator] }
    
    public func to(_ t: TargetType) -> AnimaticsReady{
        return SequentialAnimations(firstAnimator: firstAnimator.to(t), secondAnimator: secondAnimator.to(t))
    }
    
    public func getDuration() -> TimeInterval {
        return firstAnimator.getDuration() + secondAnimator.getDuration()
    }
}

final public class RepeatAnimator: AnimaticsReady, AnimaticsSettingsSettersWrapper{
    let animator: AnimaticsReady
    let repeatCount: Int
    private var completionBlocks: [AnimaticsEmptyBlock] = []

    public init(animator: AnimaticsReady, repeatCount: Int){
        self.animator = animator
        self.repeatCount = repeatCount
    }
    
    public func animateWithCompletion(_ completion: AnimaticsCompletionBlock?) {
        animateWithCompletion(completion, repeatsLeft: repeatCount)
    }
    
    fileprivate func animateWithCompletion(_ completion: AnimaticsCompletionBlock?, repeatsLeft: Int){
        if repeatsLeft == 0 {
            completion?(true)
            return
        }
        animator.animateWithCompletion { (_)  in
            self.animateWithCompletion(completion, repeatsLeft: repeatsLeft - 1)
        }
    }
    
    public func performWithoutAnimation() { }
    
    public func getSettingsSetters() -> [AnimaticsSettingsSetter] { return [animator] }
    public func cancelAnimation(_ shouldShowFinalState: Bool) {
        animator.cancelAnimation(shouldShowFinalState)
    }
    
    public func reversedAnimation() -> AnimaticsReady{ return self }
    
    public func getDuration() -> TimeInterval {
        return animator.getDuration() * TimeInterval(repeatCount)
    }
    
    public func withCompletionBlock(_ block: @escaping () -> ()) -> AnimaticsReady {
        completionBlocks.append(block)
        return self
    }
}

final public class EndlessAnimator: AnimaticsReady, AnimaticsSettingsSettersWrapper{
    let animator: AnimaticsReady
    
    public init(_ animator: AnimaticsReady){
        self.animator = animator
    }
    
    public func animateWithCompletion(_ completion: AnimaticsCompletionBlock?) {
        animator.animateWithCompletion { [weak self] _ in self?.animateWithCompletion(completion) }
    }
    
    public func performWithoutAnimation() { }
    
    public func getSettingsSetters() -> [AnimaticsSettingsSetter] { return [animator] }
    public func cancelAnimation(_ shouldShowFinalState: Bool) {
        animator.cancelAnimation(shouldShowFinalState)
    }
    public func reversedAnimation() -> AnimaticsReady{ return self }
    
    public func getDuration() -> TimeInterval {
        return TimeInterval.infinity
    }
    
    public func withCompletionBlock(_ block: @escaping () -> ()) -> AnimaticsReady {
        return self
    }
}

public extension AnimaticsReady{
    public func endless() -> EndlessAnimator { return EndlessAnimator(self) }
}

public func +(left: AnimaticsReady, right: AnimaticsReady) -> AnimaticsReady{
    return SimultaneousAnimations(firstAnimator: left, secondAnimator: right)
}

public func |->(left: AnimaticsReady, right: AnimaticsReady) -> AnimaticsReady{
    return SequentialAnimations(firstAnimator: left, secondAnimator: right)
}

public func +<T: AnimaticsTargetWaiter, U: AnimaticsTargetWaiter>(left: T, right: U) -> SimultaneousAnimationsTargetWaiter<T, U>{
    return SimultaneousAnimationsTargetWaiter(firstAnimator: left, secondAnimator: right)
}

public func |-><T: AnimaticsTargetWaiter, U: AnimaticsTargetWaiter>(left: T, right: U) -> SequentialAnimationsTargetWaiter<T, U>{
    return SequentialAnimationsTargetWaiter(firstAnimator: left, secondAnimator: right)
}


