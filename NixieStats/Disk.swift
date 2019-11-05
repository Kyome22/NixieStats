//
//  Disk.swift
//  NixieStats
//
//  Created by Takuto Nakamura on 2019/11/04.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Foundation

class Disk {
    
    func current() -> String {
        let url = NSURL(fileURLWithPath: "/")
        let keys: [URLResourceKey] = [.volumeTotalCapacityKey, .volumeAvailableCapacityForImportantUsageKey]
        guard let dict = try? url.resourceValues(forKeys: keys) else {
            return "____"
        }
        let total = (dict[URLResourceKey.volumeTotalCapacityKey] as! NSNumber).int64Value
        let free = (dict[URLResourceKey.volumeAvailableCapacityForImportantUsageKey] as! NSNumber).int64Value
        let used: Int64 = total - free
        
        let value: Double = min(99.9, round(1000.0 * Double(used) / Double(total)) / 10.0)
        return "D" + String(format: "%04.1f", value) + "%"
    }
    
}
