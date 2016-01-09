//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by Umut Bozkurt on 08/01/16.
//  Copyright © 2016 Umut Bozkurt. All rights reserved.
//

import UIKit

public class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    public let scrollView = UIScrollView()
    public var pageControl = UIPageControl()
    public var contentViews = Array<OnboardingView>()
    
    internal let containerView = UIView()
    
    public var pageControlHeight = 35
    public var pageControlBottomMargin = 15
    
    public init(contentViews: Array<OnboardingView>) {
        super.init(nibName: nil, bundle: nil)
        self.contentViews = contentViews
    }
    
    public override func loadView() {
        super.loadView()
        
        setupScrollView()
        setupContainerView()
        setupContentViews(contentViews)
        setupPageControl()
}
    
    internal func setupScrollView() {
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        
        let bindings = ["scrollView": scrollView]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
    }
    
    internal func setupContainerView() {
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let bindings = ["containerView": containerView]
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
    }
    
    internal func setupContentViews(contentViews: Array<OnboardingView>) {
        let metrics = ["viewWidth": view.bounds.size.width, "viewHeight": view.bounds.size.height]
        var bindings = Dictionary<String, OnboardingView>()
        
        var horizontalFormat = ""
        
        for (index, contentView) in contentViews.enumerate() {
            let viewName = "contentView\(index)"
            bindings.updateValue(contentView, forKey: viewName)
            horizontalFormat += "[\(viewName)(viewWidth)]"
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(contentView)
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[\(viewName)(viewHeight)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bindings))
        }
        
        horizontalFormat = String(format: "H:|%@|", horizontalFormat)
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(horizontalFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bindings))
    }
    
    internal func setupPageControl()
    {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = UIColor.redColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        pageControl.numberOfPages = contentViews.count
        
        let bindings = ["pageControl": pageControl]
        let metrics = ["margin": pageControlBottomMargin, "height": pageControlHeight]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[pageControl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pageControl(height)]-(margin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bindings))
    }

    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageControl.currentPage = Int(targetContentOffset.memory.x / scrollView.bounds.size.width)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
