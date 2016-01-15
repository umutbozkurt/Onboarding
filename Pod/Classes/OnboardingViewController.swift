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
    public var contentViews = Array<OnboardingView>() {
        didSet {
            setupContentViews(contentViews)
            view.setNeedsLayout()
        }
    }
    
    private let containerView = UIView()
    
    // MARK: Page Control
    public var pageControlHeight: Float? = 35.0
    public var bottomMargin: Float? = 15.0
    
    /// The background image that will be seen in all content views. If this is set, content views should have `alpha < 1`
    public var image: UIImage?

    /// The background video that will be seen in all content views. If this is set, content views should have `alpha < 1`
    public var videoURL: NSURL?
    
    /// UIBlurEffectStyle on background image.
    public var blurStyle: UIBlurEffectStyle?

    /// UIVIbrancyEffect on blurred background image. Defaults to `false`
    public var vibrancy: Bool? = false
    
    /// Initializes OnboardingViewController with content views
    public init(contentViews: Array<OnboardingView>) {
        self.contentViews = contentViews
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        super.loadView()

        setupScrollView()
        setupContainerView()
        setupBackgroungImage()
        setupContentViews(contentViews)
        setupPageControl()
    }
    
    private func setupScrollView() {
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
    
    private func setupContainerView() {
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let bindings = ["containerView": containerView]
        
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
    }
    
    private func setupBackgroungImage() {
        guard image != nil else {
            return
        }
        
        let backgroundImageView = UIImageView(image: image)
        let bindings = ["bgView": backgroundImageView]
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(backgroundImageView, belowSubview: scrollView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bgView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bgView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        
        
    }
    
    private func setupContentViews(contentViews: Array<OnboardingView>) {
        guard contentViews.count > 0 else {
            return
        }
        
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
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = UIColor.redColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        pageControl.numberOfPages = contentViews.count
        
        let bindings = ["pageControl": pageControl]
        let metrics = ["margin": bottomMargin!, "height": pageControlHeight!]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[pageControl]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pageControl(height)]-(margin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: bindings))
    }

    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageControl.currentPage = Int(targetContentOffset.memory.x / scrollView.bounds.size.width)
    }
}
