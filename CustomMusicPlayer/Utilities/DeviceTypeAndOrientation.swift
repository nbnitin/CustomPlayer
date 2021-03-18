//
//  DeviceTypeAndOrientation.swift
//
//  Created by Nitin Bhatia on 9/11/20.
//

//This file handle the application orientation, initial orientation is landscape, camera support all four orientations, in calling view iphone only support portait view, book in both ipad and iphone supports portait mode. This file is also responsible to chec for device type either iphone or ipad

import UIKit

struct AppUtility {
    static var oldOrientation : UIInterfaceOrientation!
    static var isAppLocked : Bool = false
    static var isRegisteredPassed : Bool = false
    
    static func getCurrentOrientation()->UIInterfaceOrientation{
        switch UIApplication.shared.statusBarOrientation{
        case .landscapeLeft:
           // self.oldOrientation = .landscapeLeft
            return .landscapeLeft
        case.portrait:
            //self.oldOrientation = .portrait
            return .portrait
        case.portraitUpsideDown:
            //self.oldOrientation = .portraitUpsideDown
            return .portraitUpsideDown
        default:
            //self.oldOrientation = .landscapeRight
            return  .landscapeRight
        }
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
        self.oldOrientation = AppUtility.getCurrentOrientation()
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.oldOrientation = AppUtility.getCurrentOrientation()
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    static func isPhone()->Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return true
        }
        return false
    }
    
    static func isPad()->Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }
}
