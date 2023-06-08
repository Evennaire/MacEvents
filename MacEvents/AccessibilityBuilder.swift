//
//  AccessibilityBuilder.swift
//  MacEvents
//
//  Created by Yueting Weng on 2023/6/7.
//

import Foundation
import AXSwift
import AppKit

final class AccessibilityBuilder: Buildable {
    
    var attributes = Attributes()
    var element = UIElement(AXUIElementCreateSystemWide())
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    
    init(_ element: AXUIElement) {
        self.element = UIElement(element)
    }
    
    func addTitle(x: CGFloat, y: CGFloat) -> AccessibilityBuilder {
        if let title: String = try? element.attribute(.title), title != "" {
            addKey(title, forKey: "title")
        } else {
            if let application = NSWorkspace.shared.frontmostApplication,
                let wrappedApplication = Application(application) {
                let hitResult = hitTest(wrappedApplication, x, y)
                let hitTitle: String = (try? hitResult?.attribute(.title)) ?? ConstDef.Error.unknownString
                addKey(hitTitle, forKey: "title")
            }
        }
        return self
    }
    
    func addSize() -> AccessibilityBuilder {
        let size: CGSize? = try? element.attribute(.size)
        addKey(size?.width ?? 0.0, forKey: "width")
        addKey(size?.height ?? 0.0, forKey: "height")
        return self
    }
    
    func addPosition() -> AccessibilityBuilder {
        let pos: CGPoint? = try? element.attribute(.position)
        addKey(pos?.x ?? 0.0, forKey: "x")
        addKey(pos?.y ?? 0.0, forKey: "y")
        return self
    }
    
    func addRole() -> AccessibilityBuilder {
        let role: String? = try? element.attribute(.role)
        addKey(role ?? ConstDef.Error.unknownString, forKey: "role")
        return self
    }
}
