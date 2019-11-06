//
//  Extensions.swift
//  NixieStats
//
//  Created by Takuto Nakamura on 2019/11/04.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

extension NSMenuItem {
    public func setAction(target: AnyObject, isShow: Bool = false, selector: Selector) {
        self.state = isShow ? NSControl.StateValue.on : NSControl.StateValue.off
        self.target = target
        self.action = selector
    }
    
    public func setShow(_ isShow: Bool) {
        self.state = isShow ? NSControl.StateValue.on : NSControl.StateValue.off
    }
}

extension NSColor {
    static let url = NSColor(named: NSColor.Name("urlColor"))!
}
