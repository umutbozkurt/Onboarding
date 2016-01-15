//
//  AppDelegate.swift
//  Onboarding
//
//  Created by Umut Bozkurt on 01/08/2016.
//  Copyright (c) 2016 Umut Bozkurt. All rights reserved.
//

import UIKit
import Onboarding

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let view1 = OnboardingView()
        view1.backgroundColor = UIColor.clearColor()
        
        let view2 = OnboardingView()
        view2.backgroundColor = UIColor.greenColor()
        
        let view3 = OnboardingView()
        view3.backgroundColor = UIColor.yellowColor()
        
//        let onboardingViewController = OnboardingViewController(contentViews: [view1, view2, view3])
//        onboardingViewController.background = UIImage(named: "amsterdam")
//        
//        window?.rootViewController = onboardingViewController
        
        (window?.rootViewController as! OnboardingViewController).contentViews = [view1, view2, view3]
        
        return true
    }
}

