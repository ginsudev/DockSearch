//
//  DCTimeZone1PickerController.m
//  
//
//  Created by Noah Little on 21/1/2022.
//

#import "include/docksearch.h"

@implementation DSSearchEnginePickerController

- (id)init {
    if (self = [super init]) {
        _prefsPlist = @"/User/Library/Preferences/com.ginsu.docksearch.plist";
        
        _tableView = [[UITableView alloc] initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStyleInsetGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = YES;
        _tableView.allowsMultipleSelection = NO;
        self.view = _tableView;
    }
    
    return self;
}

- (NSString *)title {
    return @"Select Search Engine";
}

- (NSMutableArray *)searchEngines {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObjectsFromArray:@[@"Google",
                               @"BaiDu",
                               @"Bing",
                               @"Yahoo",
                               @"DuckDuckGo",
                               @"YouTube"]];
    return arr;
}

- (NSMutableArray *)searchEnginePrefixes {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObjectsFromArray:@[@"https://www.google.com/search?q=",
                               @"https://www.baidu.com/s?wd=",
                               @"https://www.bing.com/search?q=",
                               @"https://au.search.yahoo.com/search?p=",
                               @"https://duckduckgo.com/?q=",
                               @"youtube:///results?q="]];
    return arr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = [[self searchEngines] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[self searchEnginePrefixes] objectAtIndex:indexPath.row];
    
    if ([cell.detailTextLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"DockSearch_suffix"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self searchEngines] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [[NSUserDefaults standardUserDefaults] setValue:selectedCell.detailTextLabel.text forKey:@"DockSearch_suffix"];
    
    [self save:selectedCell.detailTextLabel.text];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *highlightedCell = [tableView cellForRowAtIndexPath:indexPath];
    [highlightedCell setHighlighted:NO animated:YES];
}

- (void)save:(NSString *)string {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:_prefsPlist];
        
        if (!prefs) {
            prefs = [NSMutableDictionary dictionary];
        }
    
    [prefs setValue:string forKey:@"searchPrefix"];
    [prefs writeToFile:_prefsPlist atomically:YES];
}

@end
