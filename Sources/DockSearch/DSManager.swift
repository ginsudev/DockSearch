//
//  DSManager.swift
//
//
//  Created by Noah Little on 21/2/2022.
//

import Foundation
import UIKit
import DockSearchC

final class DSManager: NSObject {
    static let sharedInstance = DSManager()
    var searchBar: DSSearchBar!
    var isRaised: Bool = false
    var isFloatingDock: Bool = false
    
    var browserIdentifier: String {
        //Returns the bundle identifier for the device's default browser.
        return localSettings.searchPrefix.contains("youtube") ? "com.google.ios.youtube" : SearchUIDefaultBrowserAppIconImage.defaultBrowserBundleIdentifier()
    }
    
    func iconFromBundleID(_ id: String) -> UIImage {
        //Returns a UIImage object of an app's icon.
        let icon: SBIcon? = SBIconController.sharedInstance().model.expectedIcon(forDisplayIdentifier: id)
        let imageSize = CGSize(width: 60, height: 60)
        let imageInfo = SBIconImageInfo(size: imageSize,
                                        scale: UIScreen.main.scale,
                                        continuousCornerRadius: 12)
        
        let img = icon?.generateImage(with: imageInfo) as? UIImage ?? UIImage(systemName: "questionmark.square.fill")!
        return img
    }
        
    private override init() { }
}
