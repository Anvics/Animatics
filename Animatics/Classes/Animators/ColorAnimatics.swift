//
//  ColorAnimatics.swift
//  PokeScrum
//
//  Created by Nikita Arkhipov on 20.09.15.
//  Copyright © 2015 Anvics. All rights reserved.
//

import Foundation
import UIKit

public class ColorViewAnimatics: AnimationSettingsHolder, AnimaticsViewChangesPerformer {
    public typealias TargetType = UIView
    public typealias ValueType = UIColor
    
    public let value: ValueType
    
    required public init(_ v: ValueType){ value = v }
    
    public func _updateForTarget(_ t: TargetType){ fatalError() }
    public func _currentValue(_ target: TargetType) -> ValueType{ fatalError() }
}

public class BackgroundColorAnimator: ColorViewAnimatics {
    override public func _updateForTarget(_ t: TargetType) { t.backgroundColor = value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.backgroundColor! }
}

public class TintColorAnimator: ColorViewAnimatics {
    override public func _updateForTarget(_ t: TargetType) { t.tintColor = value }
    override public func _currentValue(_ target: TargetType) -> ValueType { return target.tintColor }
}
