//
//  LaunchAtLoginHelper.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 26/12/2021.
//  Copyright © 2021 Fernando Bunn. All rights reserved.
//

//Thanks to https://github.com/insidegui/StatusBuddy

import Cocoa
import ServiceManagement

struct LaunchAtLoginHelper {
    
    func killHelperIfNecessary() {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == SharedConsts.launcherAppID }.isEmpty

        SMLoginItemSetEnabled(SharedConsts.launcherAppID as CFString, true)

        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
        }
    }
    
    func checkEnabled() -> Bool {
        // Not actually deprecated according to the headers.
        guard let jobDictsPtr = SMCopyAllJobDictionaries(kSMDomainUserLaunchd) else { return false }
        
        guard let dicts = jobDictsPtr.takeUnretainedValue() as? [[String: Any]] else { return false }
        
        return dicts.contains(where: { $0["Label"] as? String == SharedConsts.launcherAppID })
    }
    
    func setEnabled(_ enabled: Bool)  {
        SMLoginItemSetEnabled(SharedConsts.launcherAppID as CFString, enabled)
    }
    
}
