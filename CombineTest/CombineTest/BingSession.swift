//
//  BingSession.swift
//  CombineTest
//
//  Created by 罗树新 on 2021/1/20.
//

import Foundation
import Tina

/// API 协议
public protocol BingSession: Sessionable {}

public extension BingSession {
    
    static func host() -> String? {
        return "cn.bing.com"
    }
        
    static func requestHandlers() -> [RequestHandleable] {
        return []
    }
    
    static func responseHandlers() -> [ResponseHandleable] {
        return []
    }
}
