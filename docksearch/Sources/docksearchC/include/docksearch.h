#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import <libgscommon/libgscommon.h>

@interface UIView (Private)
- (UIViewController *)_viewControllerForAncestor;
@end

@interface PSListController (Private)
- (void)_returnKeyPressed:(id)arg1;
@end

@interface DSSearchEnginePickerController : PSViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSString *prefsPlist;
@end
