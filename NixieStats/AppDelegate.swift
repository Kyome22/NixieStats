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
    
    private let userDefaults = UserDefaults.standard
    private let nc = NSWorkspace.shared.notificationCenter
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var button: NSStatusBarButton?
    private var settings: NSMenu?
    private var timer: Timer?
    private let cpu = CPU()
    private let memory = Memory()
    private let disk = Disk()
    
    private let keys: [String] = ["cpu", "memory", "disk"]
    private var showFlags: [Bool] = [true, true, true]
    private var flagCount: Int {
        return showFlags.reduce(0, { (res, flag) -> Int in res + (flag ? 1 : 0) })
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setUserDefaults()
        setNotifications()
        setUserInterface()
        startTimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        timer?.invalidate()
    }
    
    func setUserDefaults() {
        userDefaults.register(defaults: ["cpu" : true, "memory" : true, "disk" : true])
        for i in (0 ..< 3) {
            showFlags[i] = userDefaults.bool(forKey: keys[i])
        }
    }
    
    func setNotifications() {
        nc.addObserver(self, selector: #selector(receiveSleepNote),
                       name: NSWorkspace.willSleepNotification, object: nil)
        nc.addObserver(self, selector: #selector(receiveWakeNote),
                       name: NSWorkspace.didWakeNotification, object: nil)
    }
    
    func setUserInterface() {
        statusItem.menu = menu
        button = statusItem.button
        
        settings = menu.item(at: 0)!.submenu
        for i in (0 ..< 3) {
            settings?.item(at: i)?.setAction(target: self, isShow: showFlags[i], selector: #selector(toggle(_:)))
        }
        menu.item(at: 1)!.setAction(target: self, selector: #selector(openAbout))
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (_) in
            self.updateIndicator()
        })
        timer?.fire()
    }
    
    func convert(text: String) -> [NixieChar] {
        let nc = text.map { (c) -> NixieChar in
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
            case "%": return .percent
            case ".": return .period
            case "C": return .cpu
            case "D": return .disk
            case "M": return .memory
            default: return .clear
            }
        }
        return nc
    }

    func updateIndicator() {
        var nixieChars = [NixieChar]()
        if showFlags[0] {
            nixieChars.append(contentsOf: convert(text: cpu.current()))
            nixieChars.append(NixieChar.clear)
        }
        if showFlags[1] {
            nixieChars.append(contentsOf: convert(text: memory.current()))
            nixieChars.append(NixieChar.clear)
        }
        if showFlags[2] {
            nixieChars.append(contentsOf: convert(text: disk.current()))
            nixieChars.append(NixieChar.clear)
        }
        nixieChars.removeLast()
        
        button?.image = NixieImage.createNixie(from: nixieChars)
    }
    
    @objc func receiveSleepNote() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func receiveWakeNote() {
        startTimer()
    }
    
    @objc func toggle(_ sender: NSMenuItem) {
        showFlags[sender.tag] = !showFlags[sender.tag]
        if !showFlags.reduce(false, { (res, flag) -> Bool in res || flag }) {
            showFlags[sender.tag] = !showFlags[sender.tag]
            return
        }
        for i in (0 ..< 3) {
            settings?.item(at: i)?.setShow(showFlags[i])
        }
        userDefaults.set(showFlags[sender.tag], forKey: keys[sender.tag])
        userDefaults.synchronize()
    }
    
    @objc func openAbout() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(nil)
    }

}

