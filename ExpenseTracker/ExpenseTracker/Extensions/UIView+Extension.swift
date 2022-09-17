//
//  UIViewExtensions.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-15.
//

import Foundation
import UIKit


extension UIView {
    
    //MARK: - Layout helpers
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trialing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trialing = trialing{
            trailingAnchor.constraint(equalTo: trialing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func anchorFixedSize(size:CGSize = .zero){
        if  size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if  size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    func anchorCenter(to view:UIView, xAnchor:Bool?, yAnchor:Bool?, xConstant:CGFloat = .zero, yConstant:CGFloat = .zero){
        if let _ = xAnchor{
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xConstant).isActive = true
        }
        if let _ = yAnchor{
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant).isActive = true
        }
    }
    //MARK: - Set Corner radius to any view
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
