//
//  MZToast.swift
//  MZToast
//
//  Created by macmini_zl on 2023/4/12.
//

import UIKit

/// Toast view dismiss callback
/// - Parameters
///     - auto: meaning the toast view is auto dismiss or be covered by another toast view
public typealias MZToastCompleted = (_ auto: Bool) -> Void

public class MZToast: NSObject {
    private static let window: UIWindow? = {
        let app = UIApplication.shared
        if let window = app.delegate?.window {
            return window
        } else {
            return app.keyWindow
        }
    }()
    
    private static let WIDTH = window?.bounds.width ?? 0
    private static let HEIGHT = window?.bounds.height ?? 0
    private static let SPACEVertical = 50.0
    private static let SPACEHorizontal = 30.0
    
    /// Show toast view
    /// - Parameters:
    ///   - toast: toast content
    ///   - duration: toast display time
    ///   - position: toast view positon
    ///   - completed: toast view dismiss callback
    public static func showToast(_ toast: String, duration: TimeInterval = MZToastConfig.shared.duration, position: MZToastPosition = MZToastConfig.shared.position, completed: MZToastCompleted? = nil) {
        var point = CGPoint(x: WIDTH / 2.0, y: HEIGHT / 2.0)
        if position == .Top {
            let size = getSize(text: toast, font: MZToastConfig.shared.toastFont, size: CGSize(width: WIDTH - SPACEHorizontal * 2 - MZToastConfig.shared.paddingHorizontal * 2, height: CGFloat.greatestFiniteMagnitude))
            point = CGPoint(x: WIDTH / 2.0, y: SPACEVertical + size.height / 2.0 + MZToastConfig.shared.paddingVertical)
        } else if position == .Bottom {
            let size = getSize(text: toast, font: MZToastConfig.shared.toastFont, size: CGSize(width: WIDTH - SPACEHorizontal * 2 - MZToastConfig.shared.paddingHorizontal * 2, height: CGFloat.greatestFiniteMagnitude))
            point = CGPoint(x: WIDTH / 2.0, y: HEIGHT - (SPACEVertical + size.height / 2.0 + MZToastConfig.shared.paddingVertical))
        }
        showToast(toast, duration: duration, point: point, completed: completed)
    }
    
    /// Show loading view
    /// - Parameters:
    ///   - message: loading message
    ///   - showMask: show loading mask
    public static func showLoading(_ message: String? = nil, showMask: Bool = true) {
        var activity: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            activity = UIActivityIndicatorView(style: .large)
        } else {
            activity = UIActivityIndicatorView(style: .whiteLarge)
        }
        activity.color = MZToastConfig.shared.toastColor
        activity.startAnimating()
        
        let toastBG = UIView()
        toastBG.center = CGPoint(x: WIDTH / 2.0, y: HEIGHT / 2.0)
        toastBG.backgroundColor = MZToastConfig.shared.bgColor
        toastBG.layer.cornerRadius = MZToastConfig.shared.cornerRadius
        toastBG.layer.masksToBounds = true
        toastBG.addSubview(activity)
        
        if let toast = message {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = MZToastConfig.shared.toastColor
            label.font = MZToastConfig.shared.toastFont
            let size = getSize(text: toast, font: MZToastConfig.shared.toastFont, size: CGSize(width: WIDTH - SPACEHorizontal * 2 - MZToastConfig.shared.paddingHorizontal * 2, height: CGFloat.greatestFiniteMagnitude))
            let width = max(MZToastConfig.shared.loadingSize, size.width)
            label.frame = CGRect(x: MZToastConfig.shared.paddingHorizontal + (width - size.width) / 2.0, y: MZToastConfig.shared.paddingHorizontal + MZToastConfig.shared.loadingSize + 10, width: size.width, height: size.height)
            label.text = toast
            
            
            activity.frame = CGRect(x: MZToastConfig.shared.paddingHorizontal + (width - MZToastConfig.shared.loadingSize) / 2.0, y: MZToastConfig.shared.paddingVertical, width: MZToastConfig.shared.loadingSize, height: MZToastConfig.shared.loadingSize)
            
            toastBG.addSubview(label)
            toastBG.frame = CGRect(x: 0, y: 0, width: width + MZToastConfig.shared.paddingHorizontal * 2, height: size.height + MZToastConfig.shared.paddingVertical * 2 + MZToastConfig.shared.loadingSize + 10)
        } else {
            activity.frame = CGRect(x: MZToastConfig.shared.paddingHorizontal, y: MZToastConfig.shared.paddingVertical, width: MZToastConfig.shared.loadingSize, height: MZToastConfig.shared.loadingSize)
            toastBG.frame = CGRect(x: 0, y: 0, width: MZToastConfig.shared.loadingSize + MZToastConfig.shared.paddingHorizontal * 2, height: MZToastConfig.shared.loadingSize + MZToastConfig.shared.paddingVertical * 2)
        }
        toastBG.center = CGPoint(x: WIDTH / 2.0, y: HEIGHT / 2.0)
        
        hideLoading()
        if showMask {
            let maskView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
            maskView.backgroundColor = MZToastConfig.shared.maskColor.withAlphaComponent(0.2)
            maskView.addSubview(toastBG)
            maskView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(doNothing))
            maskView.addGestureRecognizer(tap)
            
            window?.addSubview(maskView)
            MZToastConfig.shared.messageView = maskView
        } else {
            window?.addSubview(toastBG)
            MZToastConfig.shared.messageView = toastBG
        }
    }
    
    /// Hide loading view
    public static func hideLoading() {
        MZToastConfig.shared.messageView?.removeFromSuperview()
        MZToastConfig.shared.messageView = nil
    }
    
    private static func showToast(_ toast: String, duration: TimeInterval = MZToastConfig.shared.duration, point: CGPoint = window?.center ?? CGPoint.zero, completed: MZToastCompleted? = nil) {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = MZToastConfig.shared.toastColor
        label.font = MZToastConfig.shared.toastFont
        let size = getSize(text: toast, font: MZToastConfig.shared.toastFont, size: CGSize(width: WIDTH - SPACEHorizontal * 2 - MZToastConfig.shared.paddingHorizontal * 2, height: CGFloat.greatestFiniteMagnitude))
        label.frame = CGRect(origin: .zero, size: size)
        label.center = CGPoint(x: size.width / 2 + MZToastConfig.shared.paddingHorizontal, y: size.height / 2 + MZToastConfig.shared.paddingVertical)
        label.text = toast
        
        let toastBG = UIView()
        toastBG.frame = CGRect(x: 0, y: 0, width: size.width + MZToastConfig.shared.paddingHorizontal * 2, height: size.height + MZToastConfig.shared.paddingVertical * 2)
        toastBG.center = point
        toastBG.backgroundColor = MZToastConfig.shared.bgColor
        toastBG.layer.cornerRadius = MZToastConfig.shared.cornerRadius
        toastBG.layer.masksToBounds = true
        toastBG.addSubview(label)

        NSObject.cancelPreviousPerformRequests(withTarget: self)
        MZToastConfig.shared.toastView?.removeFromSuperview()
        MZToastConfig.shared.toastCompleted?(false)
        window?.addSubview(toastBG)
        
        MZToastConfig.shared.toastView = toastBG
        MZToastConfig.shared.toastCompleted = completed
        self.perform(#selector(dismissToast), with: toastBG, afterDelay: duration)
    }
    
    @objc private static func dismissToast(_ toastView: UIView) {
        toastView.removeFromSuperview()
        MZToastConfig.shared.toastCompleted?(true)
        MZToastConfig.shared.toastCompleted = nil
        MZToastConfig.shared.toastView = nil
    }
    
    @objc private static func doNothing() {
        
    }
    
    private static func getSize(text: String, font: UIFont, size: CGSize) -> CGSize {
        var resultSize = CGSize.zero
        if text.count == 0 {
            return resultSize
        }
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        resultSize = text.boundingRect(with: CGSize(width: floor(size.width), height: floor(size.height)), options: .init(rawValue: 3), attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style], context: nil).size
        resultSize = CGSize(width: floor(resultSize.width + 1), height: floor(resultSize.height + 1))
        return resultSize
    }
}

public class MZToastConfig: NSObject {
    public static let shared = MZToastConfig()
    
    fileprivate var toastView: UIView? = nil
    fileprivate var toastCompleted: MZToastCompleted? = nil
    fileprivate var messageView: UIView? = nil
    
    public var maskColor: UIColor = UIColor.lightGray
    public var bgColor: UIColor = UIColor.lightGray
    public var toastColor: UIColor = UIColor.white
    public var toastFont: UIFont = UIFont.systemFont(ofSize: 16)
    public var paddingVertical: Double = 10.0
    public var paddingHorizontal: Double = 10.0
    public var cornerRadius: Double = 10.0
    public var duration: TimeInterval = 2.0
    public var position: MZToastPosition = .Center
    fileprivate var loadingSize: Double = 50.0
}

public enum MZToastPosition {
    case Top
    case Center
    case Bottom
}
