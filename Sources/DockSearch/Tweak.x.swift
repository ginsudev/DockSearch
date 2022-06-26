import Orion
import DockSearchC
import UIKit

struct localSettings {
    static var isEnabled: Bool!
    static var searchPrefix: String!
    static var showBGBlur: Bool!
    static var bottomSearch: Bool!
}

struct tweak: HookGroup {}

//MARK: - Dock modification and search bar init.
class SBRootFolderController_Hook: ClassHook<SBRootFolderController> {
    typealias Group = tweak

    func viewDidLoad() {
        orig.viewDidLoad()
        
        //Check if iPad dock is enabled. Don't progress any further if it is..
        DSManager.sharedInstance.isFloatingDock = target.dockIconListView.iconLocation == "SBIconLocationFloatingDock"
        
        guard !DSManager.sharedInstance.isFloatingDock else {
            return
        }
        
        //Init and add the search bar.
        DSManager.sharedInstance.searchBar = DSSearchBar(frame: CGRect(x: 15, y: 22, width: target.dockIconListView.frame.width - 30, height: 40))
        target.dockIconListView.addSubview(DSManager.sharedInstance.searchBar)
    }
    
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
        
        guard !DSManager.sharedInstance.isFloatingDock else {
            return
        }
        
        let backgroundFrame: CGRect = Ivars<MTMaterialView>(DSManager.sharedInstance.searchBar.dockView())._backgroundView.frame

        //Set frame.
        if localSettings.bottomSearch {
            DSManager.sharedInstance.searchBar.frame = CGRect(x: 15, y: backgroundFrame.height - 62, width: backgroundFrame.width - 30, height: 40)
            target.dockIconListView.additionalLayoutInsets = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        } else {
            DSManager.sharedInstance.searchBar.frame = CGRect(x: 15, y: 22, width: backgroundFrame.width - 30, height: 40)
            target.dockIconListView.additionalLayoutInsets = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        }
        
        guard !FileManager().fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/Multipla.dylib") else {
            return
        }
        
        //Horizontally centre the search bar.
        DSManager.sharedInstance.searchBar.center = CGPoint(x: target.view.center.x, y: DSManager.sharedInstance.searchBar.center.y)
    }
    
}

class SBDockView_Hook: ClassHook<SBDockView> {
    typealias Group = tweak
    
    //Make the dock taller
    func dockHeight() -> CGFloat {
        return orig.dockHeight() + 60
    }
}

//MARK: - Shift and shrink the page dots
class SBIconListPageControl_Hook: ClassHook<SBIconListPageControl> {
    typealias Group = tweak
    
    func didMoveToWindow() {
        orig.didMoveToWindow()
        
        guard !DSManager.sharedInstance.isFloatingDock else {
            return
        }
        
        guard target.delegate is SBRootFolderView else {
            return
        }
        
        target.transform = CGAffineTransform(translationX: 0, y: 10)
        target._setCustomVerticalPadding(5)
    }
}

//MARK: - Dismissing in particular circumstances...
class SBIconScrollView_Hook: ClassHook<SBIconScrollView> {
    typealias Group = tweak

    //Dismiss the dock when scrolling home screen pages.
    func _bs_willBeginScrolling() {
        orig._bs_willBeginScrolling()
        
        guard !DSManager.sharedInstance.isFloatingDock else {
            return
        }
        
        guard DSManager.sharedInstance.isRaised else {
            return
        }
        
        DSManager.sharedInstance.searchBar.dismiss()
    }
}

class CSCoverSheetViewController_Hook: ClassHook<CSCoverSheetViewController> {
    typealias Group = tweak
    
    //If the user locked the device while the dock was raised, dismiss it before the next unlock.
    func viewWillDisappear(_ animated: Bool) {
        orig.viewWillDisappear(animated)
        
        guard !DSManager.sharedInstance.isFloatingDock else {
            return
        }
        
        guard DSManager.sharedInstance.isRaised else {
            return
        }
        
        DSManager.sharedInstance.searchBar.dismiss()
    }
}

class SBSearchScrollView_Hook: ClassHook<SBSearchScrollView> {
    typealias Group = tweak

    //Prevent access to the (swipe down) spotlight search when the dock is raised.
    func gestureRecognizerShouldBegin(_ arg1: UIGestureRecognizer) -> Bool {
        return DSManager.sharedInstance.isRaised ? false : orig.gestureRecognizerShouldBegin(arg1)
    }
}

class SpringBoard_Hook: ClassHook<SpringBoard> {
    typealias Group = tweak
    
    //Dismiss the dock when opening apps.
    func frontDisplayDidChange(_ display: AnyObject?) {
        orig.frontDisplayDidChange(display)
        
        guard !DSManager.sharedInstance.isFloatingDock else {
            return
        }

        guard let display = display as? SBApplication else {
            return
        }
        
        guard display.bundleIdentifier != "com.apple.springboard" else {
            return
        }
        
        DSManager.sharedInstance.searchBar.dismiss()
    }
}

//MARK: - Preferences
func readPrefs() {
    
    let path = "/var/mobile/Library/Preferences/com.ginsu.docksearch.plist"
    
    if !FileManager().fileExists(atPath: path) {
        try? FileManager().copyItem(atPath: "Library/PreferenceBundles/docksearch.bundle/defaults.plist", toPath: path)
    }
    
    guard let dict = NSDictionary(contentsOfFile: path) else {
        return
    }
    
    //Reading values
    localSettings.isEnabled = dict.value(forKey: "isEnabled") as? Bool ?? true
    localSettings.searchPrefix = dict.value(forKey: "searchPrefix") as? String ?? "https://www.google.com/search?q="
    localSettings.showBGBlur = dict.value(forKey: "hasBG") as? Bool ?? true
    localSettings.bottomSearch = dict.value(forKey: "bottomSearch") as? Bool ?? false
}

struct DockSearch: Tweak {
    init() {
        readPrefs()
        if localSettings.isEnabled {
            tweak().activate()
        }
    }
}
