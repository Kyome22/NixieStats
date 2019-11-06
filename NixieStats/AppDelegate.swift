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
    private lazy var infoTextFields: [InfoTextField] = {
        var fields = [InfoTextField]()
        for n in (0 ..< 11) {
            let field: InfoTextField
            if n == 0 || n == 4 || n == 9 {
                field = InfoTextField(paddingLeft: 15.0, paddingRight: 5.0)
            } else {
                field = InfoTextField(paddingLeft: 30.0, paddingRight: 5.0)
            }
            fields.append(field)
        }
        return fields
    }()

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
        
        let systemInfo = menu.item(withTag: 0)!.submenu
        for n in (0 ..< 11) {
            systemInfo?.item(withTag: n)?.view = infoTextFields[n]
        }
        settings = menu.item(withTag: 1)!.submenu
        for i in (0 ..< 3) {
            settings?.item(at: i)?.setAction(target: self, isShow: showFlags[i], selector: #selector(toggle(_:)))
        }
        menu.item(withTag: 2)!.setAction(target: self, selector: #selector(openAbout))
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (_) in
            self.updateIndicator()
        })
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
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
        let cpuInfo = cpu.current()
        let memoryInfo = memory.current()
        let diskInfo = disk.current()
        
        var nixieChars = [NixieChar]()
        if showFlags[0] {
            nixieChars.append(contentsOf: convert(text: cpuInfo.indicator))
            nixieChars.append(NixieChar.clear)
        }
        if showFlags[1] {
            nixieChars.append(contentsOf: convert(text: memoryInfo.indicator))
            nixieChars.append(NixieChar.clear)
        }
        if showFlags[2] {
            nixieChars.append(contentsOf: convert(text: diskInfo.indicator))
            nixieChars.append(NixieChar.clear)
        }
        nixieChars.removeLast()
        
        button?.image = NixieImage.createNixie(from: nixieChars)
        
        infoTextFields[0].infoString = cpuInfo.percentage
        infoTextFields[1].infoString = cpuInfo.system
        infoTextFields[2].infoString = cpuInfo.user
        infoTextFields[3].infoString = cpuInfo.idle
        infoTextFields[4].infoString = memoryInfo.percentage
        infoTextFields[5].infoString = memoryInfo.pressure
        infoTextFields[6].infoString = memoryInfo.app
        infoTextFields[7].infoString = memoryInfo.wired
        infoTextFields[8].infoString = memoryInfo.compressed
        infoTextFields[9].infoString = diskInfo.percentage
        infoTextFields[10].infoString = diskInfo.capacity
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
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let mutableAttrStr = NSMutableAttributedString()
        var attr: [NSAttributedString.Key : Any] = [.foregroundColor : NSColor.textColor, .paragraphStyle : paragraph]
        mutableAttrStr.append(NSAttributedString(string: "NixieStats is an open-source software.\n", attributes: attr))
        let url = "https://github.com/Kyome22/NixieStats"
        attr = [.foregroundColor : NSColor.url, .link : url, .paragraphStyle : paragraph]
        mutableAttrStr.append(NSAttributedString(string: url, attributes: attr))
        let key = NSApplication.AboutPanelOptionKey.credits
        NSApp.orderFrontStandardAboutPanel(options: [key: mutableAttrStr])
    }

}

