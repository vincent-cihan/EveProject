//
//  GYRouterConfig.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/12.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit

let Page = GYRouterProvider<Router>()

/// 跳转控制路由，在这里添加要跳转页面
enum Router: String {
    case Home               = "GYHomeViewController"        // 首页
    case Mine               = "GYMineViewController"        // 个人中心
    case gaussianBlur       = "GYGaussianBlurViewController" // 动态高斯模糊
    case gradualNavi        = "GYGradualNaviViewController"  // 动态导航
}


extension Router: ControllerConvertible {
    // 目标类
    var target: UIViewController.Type {
        
        switch self {
        case .Home:
            return GYHomeViewController.self
        case .Mine:
            return GYMineViewController.self
        case .gaussianBlur:
            return GYGaussianBlurViewController.self
        case .gradualNavi:
            return GYGradualNaviViewController.self
        }
        
    }
    
    // 跳转方法
    var method: ControllerOperation {
        
        switch self {
        case .gaussianBlur, .gradualNavi:
            return .push
        default:
            return .push
//        case .Home, .Mine:
//            return .push
//        case .gaussianBlur:
//            return .present(parent: nil)
//        case .gradualNavi:
//            return .present(parent: UINavigationController.self)
        }
        
    }
    
    // 目标类标题
    var title: String? {
        
        switch self {
        case .Home:
            return "首页"
        case .Mine:
            return "我的"
        case .gaussianBlur:
            return "高斯模糊"
        case .gradualNavi:
            return "动态导航"
        }
        
    }
}

