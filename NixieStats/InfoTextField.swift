//
//  InfoTextField.swift
//  NixieStats
//
//  Created by Takuto Nakamura on 2019/11/06.
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

class InfoTextFieldCell: NSTextFieldCell {
    
    var paddingLeft: CGFloat = 0.0
    var paddingRight: CGFloat = 0.0
    
    override func cellSize(forBounds rect: NSRect) -> NSSize {
        var size = super.cellSize(forBounds: rect)
        size.width += (paddingLeft + paddingRight)
        return size
    }
    
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let inset = NSRect(x: rect.origin.x + paddingLeft, y: rect.origin.y,
                           width: rect.width - (paddingLeft + paddingRight), height: rect.height)
        return super.drawingRect(forBounds: inset)
    }
    
}

class InfoTextField: NSTextField {
    
    var infoString: String = "" {
        didSet {
            self.stringValue = infoString
            self.sizeToFit()
        }
    }

    init(paddingLeft: CGFloat, paddingRight: CGFloat) {
        super.init(frame: NSRect.zero)
        let cell = InfoTextFieldCell()
        cell.wraps = false
        cell.paddingLeft = paddingLeft
        cell.paddingRight = paddingRight
        self.cell = cell
        self.stringValue = ""
        self.sizeToFit()
        self.isBezeled = false
        self.isEditable = false
        self.isSelectable = false
        self.drawsBackground = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

