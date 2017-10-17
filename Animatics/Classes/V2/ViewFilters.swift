//
//  ViewFilters.swift
//  ProjectFluid
//
//  Created by Nikita Arkhipov on 15.03.16.
//  Copyright © 2016 Anvics. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    public func animatics_snapshotImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0);
        let view = self
        view.layoutIfNeeded()
        if !view.drawHierarchy(in: bounds, afterScreenUpdates: false) {
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
}

public class ViewFilterAndBackAnimator: AnimationSettingsHolder, Animatics {
    public typealias TargetType = UIView
    public typealias ValueType = Filter.Applyer
    
    public let value: ValueType
    
    fileprivate var tmpImageView: UIImageView!
    
    required public init(_ v: @escaping ValueType){ value = v }
    
    public func _animateWithTarget(_ t: TargetType, completion: AnimaticsCompletionBlock?){
        let image = t.animatics_snapshotImage()
        let ciimage = CIImage(image: image)!
        tmpImageView = UIImageView(image: UIImage(ciImage: value(ciimage)))
        tmpImageView.frame = t.bounds
        tmpImageView.alpha = 0
        t.addSubview(tmpImageView)
        
        (AlphaAnimator(1).copySettingsFrom(self) |-> AlphaAnimator(0).copySettingsFrom(self)).duration(_duration/2).to(tmpImageView).animateWithCompletion { (completed: Bool) -> Void in
            self.tmpImageView.removeFromSuperview()
            completion?(completed)
        }
    }
    
    public func _performWithoutAnimationToTarget(_ t: TargetType) { }
    
    public func _cancelAnimation(_ t: TargetType, shouldShowFinalState: Bool) {
        tmpImageView?.removeFromSuperview()
    }
    
    public func _currentValue(_ target: TargetType) -> ValueType { return value }
}
