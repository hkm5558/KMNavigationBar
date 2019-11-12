//
//  NSObject+Associated.swift
//  XQKX
//
//  Created by KM on 2018/5/23.
//  Copyright © 2018年 KM. All rights reserved.
//

import Foundation
import ObjectiveC.runtime

public enum AssociationPolicy {
    case assign
    case retain
    case copy
    case retainNonatomic
    case copyNonatomic
    
    fileprivate var policy: objc_AssociationPolicy {
        switch self {
        case .assign: return .OBJC_ASSOCIATION_ASSIGN
        case .retain: return .OBJC_ASSOCIATION_RETAIN
        case .copy: return .OBJC_ASSOCIATION_COPY
        case .retainNonatomic: return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        case .copyNonatomic: return .OBJC_ASSOCIATION_COPY_NONATOMIC
        }
    }
}

public extension NSObjectProtocol {
    
    func setAssociatedObject(_ object: Any?, forKey key: UnsafeRawPointer, policy: AssociationPolicy = .retain) {
        objc_setAssociatedObject(self, key, object, policy.policy)
    }
    
    func associatedObject<T>(for key: UnsafeRawPointer, create: (() -> T?)? = nil) -> T? {
        var object = objc_getAssociatedObject(self, key) as? T
        if object == nil, let creator = create {
            object = creator()
            setAssociatedObject(object, forKey: key)
        }
        return object
    }
    
}

