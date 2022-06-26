//
//  DSBrowserButton.swift
//  
//
//  Created by Noah Little on 27/2/2022.
//

import UIKit
import DockSearchC

class DSBrowserButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Set the button's image to the device's default browser icon.
        DispatchQueue.main.async {
            self.setImage(DSManager.sharedInstance.iconFromBundleID(DSManager.sharedInstance.browserIdentifier), for: .normal)
        }
        
        //Add a gesture that opens the browser when tapped.
        self.addTarget(self, action: #selector(openCurrentBrowser), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Fix colouring issues on our custom browser icon/button
        self.mt_removeAllVisualStyling()
    }
    
    @objc func openCurrentBrowser() {
        //Opens the browser
        (UIApplication.shared as? SpringBoard)?.launchApplication(withIdentifier: DSManager.sharedInstance.browserIdentifier, suspended: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
