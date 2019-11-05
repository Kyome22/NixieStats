//
//  NixieImage.swift
//  NixieStats
//
//  Created by Takuto Nakamura on 2019/11/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

enum NixieChar: String {
    case zero    = "0"
    case one     = "1"
    case two     = "2"
    case three   = "3"
    case four    = "4"
    case five    = "5"
    case six     = "6"
    case seven   = "7"
    case eight   = "8"
    case nine    = "9"
    case colon   = "colon"
    case percent = "percent"
    case period  = "period"
    case clear   = "clear"
    case cpu     = "cpu"
    case disk    = "disk"
    case memory  = "memory"
}

class NixieImage {

    static func createNixie(from nixies: [NixieChar], _ isDark: Bool) -> NSImage {
        let width: CGFloat = 23.0 * CGFloat(nixies.count)
        let image = NSImage(size: NSSize(width: width, height: 36.0))
        image.lockFocus()
        for n in (0 ..< nixies.count) {
            var name = "nixie_" + nixies[n].rawValue
            if nixies[n] != .clear {
                name += (isDark ? "_dark" : "_light")
            }
            let nixie = NSImage(imageLiteralResourceName: name)
            nixie.draw(in: NSRect(x: 23.0 * CGFloat(n), y: 0.0, width: 23.0, height: 36.0))
        }
        image.unlockFocus()
        image.size = NSSize(width: 0.5 * width, height: 18.0)
        return image
    }
    
}
