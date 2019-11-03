//
//  AppDelegate.swift
//  NixieStats
//
//  Created by Takuto Nakamura on 2019/11/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var button: NSStatusBarButton?
    private var timer: Timer?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = menu
        button = statusItem.button
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            let fmt = DateFormatter()
            fmt.dateFormat = "HH:mm:ss"
            let str = fmt.string(from: Date())
            let nc = str.map { (c) -> NixieChar in
                switch c {
                case "0": return .zero
                case "1": return .one
                case "2": return .two
                case "3": return .three
                case "4": return .four
                case "5": return .five
                case "6": return .six
                case "7": return .seven
                case "8": return .eight
                case "9": return .nine
                case ":": return .colon
                default: return .clear
                }
            }
            self.button?.image = NixieImage.createNixie(from: nc)
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        timer?.invalidate()
    }


}

