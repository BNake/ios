//
//  File.swift
//  Alert
//
//  Created by Nazhmeddin on 2019-02-19.
//  Copyright © 2019 Nazhmeddin. All rights reserved.
//

import UIKit


class ImageActionSheet: ActionSheetController {
    
    var tintColor: UIColor = .blue {
        didSet {
            alertController.view.tintColor = tintColor
        }
    }
    
    private(set) var alertController: UIAlertController
    private(set) weak var presentationViewController: UIViewController?
    private let cancelActionEnabled: Bool
    
    init(presentationViewController: UIViewController,
         title: String? = nil,
         message: String? = nil,
         actions: [ImageActionSheetModule],
         cancelActionEnabled: Bool = true) {
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.presentationViewController = presentationViewController
        self.cancelActionEnabled = cancelActionEnabled
        
        setupActions(actions)
    }
    
    func present() {
        if alertController.actions.isEmpty {
            return
        }
        
        presentationViewController?.present(alertController, animated: true, completion: { [weak self] in
            self?.setupTapOutsideAction()
        })
    }
    
    private func setupTapOutsideAction() {
        if !cancelActionEnabled {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
            if let superview = alertController.view.superview, let subview = superview.subviews.first {
                subview.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    private func setupActions(_ actions: [ImageActionSheetModule]) {
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: .default) { (_) in
                action.handler()
            }
            alertAction.setValue(action.image, forKey: "_image")
            alertAction.setValue(CATextLayerAlignmentMode.left, forKey: "_titleTextAlignment")
            alertController.addAction(alertAction)
        }
        
        if cancelActionEnabled {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
    }
    
    @objc private func dismiss() {
        alertController.dismiss(animated: true, completion: nil)
    }
}
