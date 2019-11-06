//
//  NixieImage.swift
//  NixieStats
//
//  Created by Takuto Nakamura on 2019/11/03.
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

    static func createNixie(from nixies: [NixieChar]) -> NSImage {
        let width: CGFloat = 23.0 * CGFloat(nixies.count)
        let image = NSImage(size: NSSize(width: width, height: 36.0))
        image.lockFocus()
        for n in (0 ..< nixies.count) {
            let name = "nixie_" + nixies[n].rawValue
            let nixie = NSImage(imageLiteralResourceName: name)
            nixie.draw(in: NSRect(x: 23.0 * CGFloat(n), y: 0.0, width: 23.0, height: 36.0))
        }
        image.unlockFocus()
        image.size = NSSize(width: 0.5 * width, height: 18.0)
        return image
    }
    
}
