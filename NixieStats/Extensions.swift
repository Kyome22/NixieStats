//
//  Extensions.swift
//  NixieStats
//
//  Created by Takuto Nakamura on 2019/11/04.
//
//  Copyright 2019 Takuto Nakamura (Kyome22)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.



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
