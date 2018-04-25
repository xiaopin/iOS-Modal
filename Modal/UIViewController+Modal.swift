//
//  UIViewController+Modal.swift
//  https://github.com/xiaopin/iOS-Modal.git
//
//  Created by xiaopin on 2018/4/18.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

import UIKit


// MARK: *** Public ***

/// 弹窗配置
class ModalConfiguration {
    
    /// 弹出的方向, 默认`.bottom`从底部弹出
    var direction: ModalDirection = .bottom
    /// 动画时长, 默认`0.5s`
    var animationDuration: TimeInterval = 0.5
    /// 点击模态窗口之外的区域是否关闭模态窗口
    var isDismissModal: Bool = true
    /// 背景透明度, 0.0~1.0, 默认`0.3`
    var backgroundOpacity: CGFloat = 0.3
    
    /// 是否使用阴影效果
    var isEnableShadow = true
    /// 阴影颜色, 默认`.black`
    var shadowColor: UIColor = .black
    /// 阴影宽度, 默认`3.0`
    var shadowWidth: CGFloat = 3.0
    /// 阴影透明度, 0.0~1.0, 默认`0.8`
    var shadowOpacity: Float = 0.8
    /// 阴影圆角, 默认`5.0`
    var shadowRadius: CGFloat = 5.0
    
    /// 是否启用背景动画
    var isEnableBackgroundAnimation = false
    /// 背景颜色(需要设置`isEnableBackgroundAnimation`为true)
    var backgroundColor = UIColor.black
    /// 背景图片(需要设置`isEnableBackgroundAnimation`为true)
    var backgroundImage: UIImage?
    
    /// 是否启用交互式转场动画(当direction == .center时无效)
    var isEnableInteractiveTransitioning: Bool = true
    /// 标记交互式是否已经开始
    /// Fix: iOS9.x and iOS10.x tap gesture is failure.
    fileprivate var isStartedInteractiveTransitioning: Bool = false
    /// 交互手势
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer?
    
    /// 默认配置
    static var `default`: ModalConfiguration {
        return ModalConfiguration()
    }
    
    init() {}
    
    /// 控制器弹出方向
    enum ModalDirection {
        case top, right, bottom, left, center
    }
    
}


/// runtime key
private var key: Void?

// MARK: -
extension UIViewController {
    
    /// 显示一个模态视图控制器
    ///
    /// - Parameters:
    ///   - contentViewController:  模态视图控制器
    ///   - contentSize:            模态视图宽高
    ///   - configuration:          模态窗口的配置信息
    ///   - completion:             模态窗口显示完毕时的回调
    @available(iOS 8.0, *)
    func presentModalViewController(_ contentViewController: UIViewController, contentSize: CGSize, configuration: ModalConfiguration = .default, completion: (() -> Void)? = nil) {
        if let _ = presentedViewController { return }
        contentViewController.modalPresentationStyle = .custom
        contentViewController.preferredContentSize = contentSize
        
        let transitioningDelegate = ModalTransitioningDelegate(configuration: configuration)
        contentViewController.transitioningDelegate = transitioningDelegate
        // Keep strong references.
        objc_setAssociatedObject(contentViewController, &key, transitioningDelegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        present(contentViewController, animated: true, completion: completion)
    }
    
    
    /// 显示一个模态视图控制器
    ///
    /// 内部会创建一个UIViewController并将contentView添加到该控制器的view上,并添加`距离父视图上下左右均为0`的约束.
    /// 如果需要手动关闭模态窗口,则`谁弹出谁负责关闭`,即`self.presentedViewController?.dismiss(animated: true, completion: nil)`
    ///
    /// - Parameters:
    ///   - contentView:    模态视图
    ///   - contentSize:    模态视图宽高
    ///   - configuration:  模态窗口配置信息
    ///   - completion:     模态窗口显示完毕时的回调
    @available(iOS 8.0, *)
    func presentModalView(_ contentView: UIView, contentSize: CGSize, configuration: ModalConfiguration = .default, completion: (() -> Void)? = nil) {
        let contentViewController = UIViewController()
        contentViewController.view.backgroundColor = .clear
        contentViewController.view.addSubview(contentView)
        
        let views = ["contentView": contentView]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: .directionLeadingToTrailing, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: .directionLeadingToTrailing, metrics: nil, views: views))
        
        presentModalViewController(contentViewController, contentSize: contentSize, configuration: configuration, completion: completion)
    }
    
}


// MARK: *** Private ***

// MARK: -
private class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let configuration: ModalConfiguration
    
    init(configuration: ModalConfiguration) {
        self.configuration = configuration
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = ModalPresentationController(presentedViewController: presented, presenting: presenting, configuration: configuration)
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalAnimatedTransitioning(configuration: configuration, isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalAnimatedTransitioning(configuration: configuration, isPresentation: false)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if configuration.isEnableInteractiveTransitioning && configuration.isStartedInteractiveTransitioning {
            return ModalPercentDrivenInteractiveTransition(configuration: configuration)
        }
        return nil
    }
    
}


// MARK: -
private class ModalPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    private let configuration: ModalConfiguration
    private var transitionContext: UIViewControllerContextTransitioning?
    private var beganTouchPoint: CGPoint?
    
    init(configuration: ModalConfiguration) {
        self.configuration = configuration
        super.init()
        guard let panGestureRecognizer = configuration.panGestureRecognizer else { return }
        panGestureRecognizer.addTarget(self, action: #selector(gestureRecognizeDidUpdate(_:)))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
    @objc private func gestureRecognizeDidUpdate(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            // 开始状态由`ModalPresentationController`进行处理,不会走到这里
            break
        case .changed:
            if nil == beganTouchPoint {
                guard let transitionContext = transitionContext else { return }
                let transitionContainerView = transitionContext.containerView
                beganTouchPoint = sender.location(in: transitionContainerView)
            }
            update(percentForGesture(sender))
        case .ended:
            (percentForGesture(sender) > 0.3) ? finish() : cancel()
            beganTouchPoint = nil
        default:
            beganTouchPoint = nil
            cancel()
        }
    }
    
    private func percentForGesture(_ sender: UIPanGestureRecognizer) -> CGFloat {
        guard
            let transitionContext = transitionContext,
            let beganTouchPoint = beganTouchPoint,
            let modalView = transitionContext.viewController(forKey: .from)?.view
        else { return 0.0 }
        
        let transitionContainerView = transitionContext.containerView
        let currentPoint = sender.location(in: transitionContainerView)
        let width = modalView.bounds.width
        let height = modalView.bounds.height
        
        switch configuration.direction {
        case .top:
            if currentPoint.y < beganTouchPoint.y {
                let offset = beganTouchPoint.y - currentPoint.y
                return offset / height
            }
        case .right:
            if currentPoint.x > beganTouchPoint.x {
                let offset = currentPoint.x - beganTouchPoint.x
                return offset / width
            }
        case .bottom:
            if currentPoint.y > beganTouchPoint.y {
                let offset = currentPoint.y - beganTouchPoint.y
                return offset / height
            }
        case .left:
            if currentPoint.x < beganTouchPoint.x {
                let offset = beganTouchPoint.x - currentPoint.x
                return offset / width
            }
        case .center: // None, Not supoort
            break
        }
        return 0.0
    }
    
}


// MARK: -
private class ModalAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresentation: Bool
    let configuration: ModalConfiguration
    
    init(configuration: ModalConfiguration, isPresentation: Bool) {
        self.configuration = configuration
        self.isPresentation = isPresentation
    }
    
    /// 返回动画之行时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return configuration.animationDuration
    }
    
    /// 执行动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        if isPresentation, let toView = toView {
            transitionContext.containerView.addSubview(toView)
        }
        
        let animatingVC = isPresentation ? toVC : fromVC
        let finalFrame = transitionContext.finalFrame(for: animatingVC)
        
        switch configuration.direction {
        case .top:
            animatingVC.view.frame  = isPresentation ? finalFrame.offsetBy(dx: 0.0, dy: -finalFrame.height) : finalFrame
        case .right:
            animatingVC.view.frame  = isPresentation ? finalFrame.offsetBy(dx: finalFrame.width, dy: 0.0) : finalFrame
        case .bottom:
            animatingVC.view.frame  = isPresentation ? finalFrame.offsetBy(dx: 0.0, dy: finalFrame.height) : finalFrame
        case .left:
            animatingVC.view.frame  = isPresentation ? finalFrame.offsetBy(dx: -finalFrame.width, dy: 0.0) : finalFrame
        case .center:
            animatingVC.view.frame  = finalFrame
            animatingVC.view.alpha = isPresentation ? 0.0 : 1.0
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            switch self.configuration.direction {
            case .top:
                animatingVC.view.frame  = self.isPresentation ? finalFrame : finalFrame.offsetBy(dx: 0.0, dy: -finalFrame.height)
            case .right:
                animatingVC.view.frame  = self.isPresentation ? finalFrame : finalFrame.offsetBy(dx: finalFrame.width, dy: 0.0)
            case .bottom:
                animatingVC.view.frame  = self.isPresentation ? finalFrame : finalFrame.offsetBy(dx: 0.0, dy: finalFrame.height)
            case .left:
                animatingVC.view.frame  = self.isPresentation ? finalFrame : finalFrame.offsetBy(dx: -finalFrame.width, dy: 0.0)
            case .center:
                animatingVC.view.alpha = self.isPresentation ? 1.0 : 0.0
            }
        }) { (_) in
            let wasCancelled = transitionContext.transitionWasCancelled
            if !self.isPresentation && !wasCancelled {
                fromView?.removeFromSuperview()
            }
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    
}


// MARK: -
private class ModalPresentationController: UIPresentationController {
    
    private let configuration: ModalConfiguration
    private var animatingView: UIView?
    private let backgroundView = UIImageView()
    private let dimmingView = UIView()
    /// 是否正在交互
    private var isInteractiving: Bool = false
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, configuration: ModalConfiguration) {
        self.configuration = configuration
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction(_:)))
        dimmingView.addGestureRecognizer(tap)
    }
    
    /// 返回模态窗口的frame
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerSize = containerView?.bounds.size else {
            return .zero
        }
        var presentedViewFrame = CGRect.zero
        let width = min(containerSize.width, presentedViewController.preferredContentSize.width)
        let height = min(containerSize.height, presentedViewController.preferredContentSize.height)
        
        presentedViewFrame.size = CGSize(width: width, height: height)
        let x: CGFloat, y: CGFloat
        switch configuration.direction {
        case .top:
            x = (containerSize.width - width) / 2
            y = 0.0
        case .right:
            x = containerSize.width - width
            y = (containerSize.height - height) / 2
        case .bottom:
            x = (containerSize.width - width) / 2
            y = containerSize.height - height
        case .left:
            x = 0.0
            y = (containerSize.height - height) / 2
        case .center:
            x = (containerSize.width - width) / 2
            y = (containerSize.height - height) / 2
        }
        presentedViewFrame.origin = CGPoint(x: x, y: y)
        return presentedViewFrame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        backgroundView.frame = containerView?.bounds ?? .zero
        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        // 启用背景动画,需要截屏保存当前屏幕图像
        if configuration.isEnableBackgroundAnimation {
            if let window = UIApplication.shared.keyWindow,
                let snapshotView = window.snapshotView(afterScreenUpdates: true) {
                let views = ["view": snapshotView]
                animatingView = snapshotView
                backgroundView.addSubview(snapshotView)
                snapshotView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: views))
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: views))
            }
            backgroundView.backgroundColor = configuration.backgroundColor
            backgroundView.image = configuration.backgroundImage
            containerView?.addSubview(backgroundView)
        }
        
        // 添加阴影效果
        if configuration.isEnableShadow {
            let shadowWidth = abs(configuration.shadowWidth)
            presentedView?.layer.shadowColor = configuration.shadowColor.cgColor
            switch configuration.direction {
            case .top:
                presentedView?.layer.shadowOffset = CGSize(width: shadowWidth, height: shadowWidth)
            case .right:
                presentedView?.layer.shadowOffset = CGSize(width: -shadowWidth, height: shadowWidth)
            case .bottom, .left, .center:
                presentedView?.layer.shadowOffset = CGSize(width: shadowWidth, height: -shadowWidth)
            }
            presentedView?.layer.shadowRadius = configuration.shadowRadius
            presentedView?.layer.shadowOpacity = configuration.shadowOpacity
            presentedView?.layer.shouldRasterize = true
            presentedView?.layer.rasterizationScale = UIScreen.main.scale
        }
        
        // 启用手势交互功能,添加交互手势
        if configuration.isEnableInteractiveTransitioning && configuration.direction != .center {
            let panGestureRecognizer = UIPanGestureRecognizer(target: nil, action: nil)
            containerView?.addGestureRecognizer(panGestureRecognizer)
            self.configuration.panGestureRecognizer = panGestureRecognizer
            panGestureRecognizer.addTarget(self, action: #selector(gestureRecognizeDidUpdate(_:)))
        }
        
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: configuration.backgroundOpacity)
        dimmingView.alpha = 0.0
        containerView?.addSubview(dimmingView)
        
        // 执行背景动画
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 1.0
            if self.configuration.isEnableBackgroundAnimation {
                let animation = self.backgroundTranslateAnimation(true)
                self.animatingView?.layer.add(animation, forKey: nil)
            }
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        if configuration.isEnableInteractiveTransitioning && isInteractiving { return }
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 0.0
            if self.configuration.isEnableBackgroundAnimation {
                let animation = self.backgroundTranslateAnimation(false)
                self.animatingView?.layer.add(animation, forKey: nil)
            }
        }, completion: nil)
    }
    
    @objc private func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        if configuration.isDismissModal {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func gestureRecognizeDidUpdate(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            isInteractiving = true
            configuration.isStartedInteractiveTransitioning = true
            presentedViewController.dismiss(animated: true, completion: nil)
        case .changed:
            break
        default:
            isInteractiving = false
            configuration.isStartedInteractiveTransitioning = false
        }
    }
    
    private func backgroundTranslateAnimation(_ forward: Bool) -> CAAnimationGroup {
        let iPad = UI_USER_INTERFACE_IDIOM() == .pad
        let translateFactor: CGFloat = iPad ? -0.08 : -0.04
        let rotateFactor: Double = iPad ? 7.5 : 15.0
        
        var t1 = CATransform3DIdentity
        t1.m34 = CGFloat(1.0 / -900)
        t1 = CATransform3DScale(t1, 0.95, 0.95, 1.0)
        t1 = CATransform3DRotate(t1, CGFloat(rotateFactor * Double.pi / 180.0), 1.0, 0.0, 0.0)
        
        var t2 = CATransform3DIdentity
        t2.m34 = t1.m34
        t2 = CATransform3DTranslate(t2, 0.0, presentedViewController.view.frame.size.height * translateFactor, 0.0)
        t2 = CATransform3DScale(t2, 0.8, 0.8, 1.0)
        
        let animation1 = CABasicAnimation(keyPath: "transform")
        animation1.toValue = NSValue(caTransform3D: t1)
        animation1.duration = configuration.animationDuration / 2
        animation1.fillMode = kCAFillModeForwards
        animation1.isRemovedOnCompletion = false
        animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let animation2 = CABasicAnimation(keyPath: "transform")
        animation2.toValue = NSValue(caTransform3D: forward ? t2 : CATransform3DIdentity)
        animation2.beginTime = animation1.duration
        animation2.duration = animation1.duration
        animation2.fillMode = kCAFillModeForwards
        animation2.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.fillMode = kCAFillModeForwards
        group.isRemovedOnCompletion = false
        group.duration = configuration.animationDuration
        group.animations = [animation1, animation2]
        return group
    }
    
}
