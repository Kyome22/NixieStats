//
//  InfoTextField.swift
//  NixieStats
//
//  Created by Takuto Nakamura on 2019/11/06.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

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

