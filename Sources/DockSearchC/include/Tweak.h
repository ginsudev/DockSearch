#import <UIKit/UIKit.h>

struct SBIconImageInfo {
    struct CGSize size;
    double scale;
    double continuousCornerRadius;
};
@interface SBIcon : NSObject
@property (nonatomic,copy,readonly) NSString * displayName;
- (UIImage *)generateIconImageWithInfo:(struct SBIconImageInfo)arg1;
@end

@interface SBIconModel : NSObject
- (SBIcon *)expectedIconForDisplayIdentifier:(id)arg1;
@end

@interface SBIconController : NSObject
@property (nonatomic,retain) SBIconModel * model;
+ (instancetype)sharedInstance;
@end

@interface SpringBoard : UIApplication
+ (id)sharedApplication;
- (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface SBApplication : NSObject
@property (nonatomic,readonly) NSString * displayName;
@property (nonatomic,readonly) NSString * bundleIdentifier;
@end

@interface SBApplicationController : NSObject
+ (instancetype)sharedInstance;
- (SBApplication *)applicationWithBundleIdentifier:(NSString *)arg1;
@end

@interface SearchUIDefaultBrowserAppIconImage : NSObject
+ (NSString *)defaultBrowserBundleIdentifier;
@end

@interface SBIconScrollView : UIScrollView

@end

@interface SBHFeatherBlurView : UIView

@end

@interface SBHSearchTextField : UISearchTextField
- (void)setAlignmentBehavior:(long long)arg1 animated:(BOOL)arg2;
- (CGRect)_frameForLeftViewWithinBounds:(CGRect)arg1 alignment:(long long)arg2;
@end

@interface SBHSearchBar : UIView
@property (nonatomic,retain) SBHSearchTextField * searchTextField;
@property (nonatomic,readonly) SBHFeatherBlurView * backgroundView;
- (instancetype)initWithFrame:(CGRect)arg1;
- (BOOL)canResignFirstResponder;
- (BOOL)textFieldShouldReturn:(id)arg1;
- (void)textFieldDidBeginEditing:(id)arg1;
- (BOOL)resignFirstResponder;
- (void)_cancelButtonWasHit:(id)arg1;
- (void)setShowsCancelButton:(BOOL)arg1 animated:(BOOL)arg2;
@end

@interface SBDockIconListView : UIView
@property (nonatomic, assign, readwrite) UIEdgeInsets additionalLayoutInsets;
@end

@interface SBRootFolderDockIconListView : SBDockIconListView
@end

@interface SBDockView : UIView

@end

@interface SBRootFolderView : UIView

@end

@interface SBFolderController : UIViewController
@property (nonatomic,readonly) SBDockIconListView * dockIconListView;
@end

@interface SBRootFolderController : SBFolderController
@end

@interface MTMaterialView : UIView

@end

@interface _UIPageControlContentView : UIView

@end

@interface SBSearchScrollView : UIView

@end

@interface CSCoverSheetViewController : UIViewController

@end

@interface SBIconListPageControl : UIPageControl
@property (nonatomic, weak, readwrite) id delegate;
- (void)_setCustomVerticalPadding:(CGFloat)padding;
@end

@interface UIView (Private)
- (UIViewController *)_viewControllerForAncestor;
- (void)mt_removeAllVisualStyling;
@end
