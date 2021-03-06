//
//  UIViewController+TopVC.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/12.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    private class func getCurrentWindow() -> UIWindow? {
        var window: UIWindow? = UIApplication.shared.keyWindow
        if let w = window, w.windowLevel != UIWindow.Level.normal {
            for tempWindow in UIApplication.shared.windows {
                if tempWindow.windowLevel == UIWindow.Level.normal  {
                    window = tempWindow
                    break
                }
            }
        }
        return window
    }
    
    // MARK: 获取当前window上controller
    private class func getTopWindowController(_ viewController: UIViewController?) -> UIViewController? {
        guard let controller = viewController else {
            return nil
        }
        if let VC = controller.presentedViewController {
            return getTopWindowController(VC)
        }
        if controller.isKind(of: UISplitViewController.self) {
            let VC = controller as! UISplitViewController
            if VC.viewControllers.count > 0 {
                return getTopWindowController(VC.viewControllers.last)
            }
            return VC
        }
        if controller.isKind(of: UINavigationController.self) {
            let VC = controller as! UINavigationController
            if VC.viewControllers.count > 0 {
                return getTopWindowController(VC.topViewController)
            }
            return VC
        }
        if controller.isKind(of: UITabBarController.self) {
            let VC = controller as! UITabBarController
            guard let controllers = VC.viewControllers, controllers.count > 0 else {
                return VC
            }
            return getTopWindowController(VC.selectedViewController)
        }
        return controller
    }
    class func topWindowController() -> UIViewController? {
        guard let window = UIViewController.getCurrentWindow() else {
            return nil;
        }
        return getTopWindowController(window.rootViewController!)
    }
}

