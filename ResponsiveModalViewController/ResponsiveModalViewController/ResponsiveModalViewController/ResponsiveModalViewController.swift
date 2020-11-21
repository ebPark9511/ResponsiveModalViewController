//
//  ResponsiveModalViewController.swift
//  ResponsiveModalView
//
//  Created by 박은비 on 2020/11/17.
//  Copyright © 2020 박은비. All rights reserved.
//
 
import UIKit

open class ResponsiveModalViewController: UIViewController {
    private var contentView: UIView!
    
    var cardFrameViewHiehgt: CGFloat = 0
    @objc var corner: CGFloat = 10.0 // default
    
    private var showCardViewAnimator: UIViewPropertyAnimator? = nil
    private var hideCardViewAnimator: UIViewPropertyAnimator? = nil
    
    @IBOutlet private weak var dimView: UIView!
    
    @IBOutlet private weak var cardFrameView: UIView!
    @IBOutlet private weak var cardFrameViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cardContentFrameView: UIView!
     
    @objc
    init(withView: UIView) {
        self.contentView = withView
        super.init(nibName: nil, bundle: nil)
    }
      
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    
}

// MARK: - Action
extension ResponsiveModalViewController {
    @IBAction private func didTapGestureDimView(_ sender: Any?) {
        hideCardViewAnimator?.startAnimation()
        hideCardViewAnimator?.addCompletion({ (position) in
            if position == .end {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
     
    @IBAction private func didPanGestureCardView(_ sender: Any) {
        if let panRecognizer = sender as? UIPanGestureRecognizer {
            let translation = panRecognizer.translation(in: self.cardFrameView)
            
            switch panRecognizer.state {
            case .changed:
                if translation.y < 0 { return }
                cardFrameViewBottomConstraint.constant = translation.y
                dimView.backgroundColor = UIColor(white: 0, alpha: 0.5 - (cardFrameViewBottomConstraint.constant / cardFrameViewHiehgt) / 2)
                
                
            case .ended:
                if (cardFrameViewBottomConstraint.constant < (cardFrameViewHiehgt / 2.8) ) {
                    settingAnimation()
                    showCardViewAnimator?.startAnimation()
                    return
                }
                 
                didTapGestureDimView(nil)
                return
                
            default:
                break
            }
            
        }
    }
}


// MARK: - Layout, UI, Animation
extension ResponsiveModalViewController {
    private func initUI() {
        dimView?.backgroundColor = UIColor.clear
         
        cardContentFrameView.addSubview(contentView)
        
        contentView.topAnchor.constraint(equalTo: cardContentFrameView.topAnchor
                                  ,constant: 0).isActive = true
        contentView.leftAnchor.constraint(equalTo: cardContentFrameView.leftAnchor
                                   , constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: cardContentFrameView.rightAnchor
                                    , constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: cardContentFrameView.bottomAnchor
                                     , constant: 0).isActive = true
        if 0 < corner {
            cardFrameView.clipsToBounds = true
            cardFrameView.layer.cornerRadius = corner
            cardFrameView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
         
        if let contentViewHeight = contentView.constraints
            .first(where:  {$0.identifier == "ContentViewHeight"})?.constant {
            cardFrameViewHiehgt = contentViewHeight
            cardFrameViewBottomConstraint.constant = contentViewHeight
        }
     
        view.layoutIfNeeded()
        view.setNeedsLayout()
        
        /* Setting Animation */
        settingAnimation()

    }
     
    private func setUI() {
        showCardViewAnimator?.startAnimation()
    }
    
    private func settingAnimation() {
        showCardViewAnimator = UIViewPropertyAnimator(duration: 0.2,
                                                      curve: .easeInOut,
                                                      animations: showCardView)
        
        hideCardViewAnimator = UIViewPropertyAnimator(duration: 0.2,
                                                      curve: .easeInOut,
                                                      animations: hideCardView)
    }
    
    private func showCardView() {
        dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.cardFrameViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
        view.setNeedsLayout()
    }
     
    private func hideCardView() {
        dimView.backgroundColor = UIColor(white: 0, alpha: 0)
        self.cardFrameViewBottomConstraint.constant = cardFrameViewHiehgt
        view.layoutIfNeeded()
        view.setNeedsLayout()
    }
    
}

