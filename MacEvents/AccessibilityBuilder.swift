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
        var instance = self
        if let title: String = try? element.attribute(.title), title != "" {
            instance.addKey(title, forKey: "title")
        } else {
            if let application = NSWorkspace.shared.frontmostApplication,
                let wrappedApplication = Application(application) {
                let hitResult = hitTest(wrappedApplication, x, y)
                let hitTitle: String = (try? hitResult?.attribute(.title)) ?? ConstDef.Error.unknownString
                instance.addKey(hitTitle, forKey: "title")
            }
        }
        return instance
    }
    
    func addSize() -> AccessibilityBuilder {
        var instance = self
        let size: CGSize? = try? element.attribute(.size)
        instance.addKey(size?.width ?? 0.0, forKey: "width")
        instance.addKey(size?.height ?? 0.0, forKey: "height")
        return self
    }
    
    func addPosition() -> AccessibilityBuilder {
        var instance = self
        let pos: CGPoint? = try? element.attribute(.position)
        instance.addKey(pos?.x ?? 0.0, forKey: "x")
        instance.addKey(pos?.y ?? 0.0, forKey: "y")
        return self
    }
    
    func addRole() -> AccessibilityBuilder {
        var instance = self
        let role: String? = try? element.attribute(.role)
        instance.addKey(role ?? ConstDef.Error.unknownString, forKey: "role")
        return self
    }
}
