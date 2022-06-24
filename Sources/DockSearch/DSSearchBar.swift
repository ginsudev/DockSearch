//
//  DSSearchBar.swift
//  
//
//  Created by Noah Little on 21/2/2022.
//

import UIKit
import Orion
import DockSearchC

class DSSearchBar: SBHSearchBar {
    override init(frame arg1: CGRect) {
        super.init(frame: arg1)
        
        //Override the magnifying glass icon with our custom browser icon/button.
        self.searchTextField.leftView = DSBrowserButton(frame: self.searchTextField._frameForLeftView(withinBounds: self.searchTextField.bounds, alignment: 1))
        //Make the placeholder text show the name of the browser.
        self.searchTextField.placeholder = displayNameForCurrentBrowser()
        //Make everything left-aligned.
        self.searchTextField.setAlignmentBehavior(1, animated: false)
        //Fix colouring issues on our custom browser icon/button
        self.searchTextField.leftView!.mt_removeAllVisualStyling()
    }
    
    override func textFieldShouldReturn(_ arg1: Any!) -> Bool {
        //Search for the text we entered, then clear input and dismiss the search bar.
        search(withText: self.searchTextField.text!)
        self.searchTextField.text = nil
        dismiss()
        return super.textFieldShouldReturn(arg1)
    }
    
    override func _cancelButtonWasHit(_ arg1: Any!) {
        //Dismisses the search bar when the 'cancel' button is tapped.
        dismiss()
        super._cancelButtonWasHit(arg1)
    }
    
    override func textFieldDidBeginEditing(_ arg1: Any!) {
        //Raise the dock when typing begins.
        super.textFieldDidBeginEditing(arg1)
        animate(withContext: 1)
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        //Remove this annoying view that plagues devices with a random blurry bar at the top of the screen...
        if subview == self.backgroundView {
            subview.removeFromSuperview()
        }

        //Hide the search bar's blurry background if that's what the user wants.
        guard !localSettings.showBGBlur else {
            return
        }
        
        if subview == self.searchTextField {
            for view in subview.subviews {
                if view is MTMaterialView {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    func search(withText text: String) {
        //Search for the text the user inputted.
        
        let encodedString = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlFromEncoded = URL(string: encodedString ?? "")
        
        guard !text.isEmpty else {
            return
        }
        
        if urlFromEncoded != nil && urlFromEncoded?.scheme != nil && urlFromEncoded?.host != nil {
            UIApplication.shared.open(urlFromEncoded!)
        } else {
            let urlText = encodedString!.replacingOccurrences(of: "+", with: "%2b")
            UIApplication.shared.open(URL(string: "\(localSettings.searchPrefix!)\(urlText)")!)
        }
    }
    
    @objc func dismiss() {
        //Dismiss the keyboard, dock and hide the cancel button.
        self.resignFirstResponder()
        setShowsCancelButton(false, animated: true)
        animate(withContext: 0)
    }
    
    func animate(withContext context: Int) {
        //Context types
        //1 = Raise the search bar
        //2 = Lower the search bar
        
        var transformation: CGAffineTransform {
            switch context {
            case 0:
                DSManager.sharedInstance.isRaised = false
                return CGAffineTransform.identity
            case 1:
                DSManager.sharedInstance.isRaised = true
                return CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height - dockView().frame.height) + 100)
            default:
                DSManager.sharedInstance.isRaised = false
                return CGAffineTransform.identity
            }
        }
        
        //Animate the view!
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            self.dockView().transform = transformation
        })
    }
    
    func displayNameForCurrentBrowser() -> String {
        //Returns a string to be shown as a placeholder on the search bar.
        let application = SBApplicationController.sharedInstance().application(withBundleIdentifier: DSManager.sharedInstance.browserIdentifier)
        return application?.displayName ?? "Search"
    }
    
    func dockView() -> SBDockView {
        /* Cycle through superviews until we find the SBDockView. This method of finding the SBDockView
         allows for compatibility with some other dock tweaks like Multipla. */
        
        var superDuperView: AnyObject? = self.superview
        
        while !(superDuperView is SBDockView) {
            superDuperView = superDuperView?.superview
        }
        
        return superDuperView as! SBDockView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
