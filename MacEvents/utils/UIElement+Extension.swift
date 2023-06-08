//
//  UIElement+Extension.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/6/7.
//

import Foundation
import AXSwift
import AppKit

func hitTest(_ root: UIElement, _ x: Double, _ y: Double) -> [UIElement] {
    guard let children: [AXUIElement] = try? root.attribute(.children) else {
        return []
    }
    
    var ans = [UIElement]()
    let position: CGPoint = (try? root.attribute(.position)) ?? .zero
    let size: CGSize = (try? root.attribute(.size)) ?? .zero
    let rect = CGRect(x: position.x, y: position.y, width: size.width, height: size.height)
    if rect.contains(CGPoint(x: x, y: y)) {
        ans.append(root)
    }
    
    for child in children.map(UIElement.init) {
        ans += hitTest(child, x, y)
    }
    
    return ans
}

func hitTest(_ root: UIElement, _ x: Double, _ y: Double) -> UIElement? {
    guard let children: [AXUIElement] = try? root.attribute(.children) else {
        return nil
    }
    
    let position: CGPoint = (try? root.attribute(.position)) ?? .zero
    let size: CGSize = (try? root.attribute(.size)) ?? .zero
    let rect = CGRect(x: position.x, y: position.y, width: size.width, height: size.height)
    if rect.contains(CGPoint(x: x, y: y)) {
        return root
    }
    
    for child in children.map(UIElement.init) {
        if let hitResult = hitTest(child, x, y) {
            return hitResult
        }
    }
    
    return nil
}

func hitTest(_ root: UIElement, _ x: CGFloat, _ y: CGFloat) -> UIElement? {
    return hitTest(root, Double(x), Double(y))
}

//extension UIElement {
//    
//    var title: String? {
//        let _title: String? = try? attribute(.title)
//        return _title
//    }
//}
