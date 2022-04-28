//
//  requestPermission.swift
//  한들
//
//  Created by 강희영 on 2022/04/28.
//

import AdSupport
import AppTrackingTransparency
func requestPermission() {
    ATTrackingManager.requestTrackingAuthorization { status in
        switch status {
        case .authorized:
            // Tracking authorization dialog was shown
            // and we are authorized print("Authorized")
            // Now that we are authorized we can get the IDFA
            print(ASIdentifierManager.shared().advertisingIdentifier)
        case .denied:
            // Tracking authorization dialog was
            // shown and permission is denied
            print("Denied")
        case .notDetermined:
            // Tracking authorization dialog has not been shown
            print("Not Determined")
        case .restricted:
            print("Restricted")
        @unknown default:
            print("Unknown")
        }
    }
}
