//
//  Disk.swift
//  NixieStats
//
//  Created by Takuto Nakamura on 2019/11/04.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Foundation

struct DiskInfo {
    var indicator: String = "D00.0%"
    var percentage: String = "Disk: 0.0%"
    var capacity: String = "0.0 GB free out of 0.0 GB"
}

class Disk {
    
    func current() -> DiskInfo {
        let url = NSURL(fileURLWithPath: "/")
        let keys: [URLResourceKey] = [.volumeTotalCapacityKey, .volumeAvailableCapacityForImportantUsageKey]
        guard let dict = try? url.resourceValues(forKeys: keys) else {
            return DiskInfo()
        }
        let total = (dict[URLResourceKey.volumeTotalCapacityKey] as! NSNumber).int64Value
        let free = (dict[URLResourceKey.volumeAvailableCapacityForImportantUsageKey] as! NSNumber).int64Value
        let used: Int64 = total - free
            
        let value: Double = min(99.9, round(1000.0 * Double(used) / Double(total)) / 10.0)
        let totalStr = ByteCountFormatter.string(fromByteCount: total, countStyle: ByteCountFormatter.CountStyle.decimal)
        let freeStr = ByteCountFormatter.string(fromByteCount: free, countStyle: ByteCountFormatter.CountStyle.decimal)
        
        return DiskInfo(indicator: String(format: "D%04.1f%%", value),
                        percentage: "Disk: \(value)%",
                        capacity: "\(freeStr) free out of \(totalStr)")
    }
    
}
