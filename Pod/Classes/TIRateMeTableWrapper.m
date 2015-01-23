//
//  TITableDataSourceWrapper.m
//  touchin-rateme
//
//  Created by Tony Larin on 09/01/15.
//
//

#import "TIRateMeTableWrapper.h"
#import "TIRateMeCellTableViewCell.h"
#import "TIAnalytics.h"

@implementation TIRateMeTableWrapper

bool (^shouldShow)(void);
NSString* UD_SHOWN_KEY = @"TIRateMeShown";
NSString* UD_FINISHED_KEY = @"TIRateMeFinished";


- (TIRateMeTableWrapper*) initWithDataSource:(id<UITableViewDataSource>) dataSource
                                   tableDelegate:(id<UITableViewDelegate>) delegate
                                      shouldShow:(bool (^)(void))shouldShowParam {
    self = [super init];
    _wrappedDataSource = dataSource;
    _wrappedDelegate = delegate;
    shouldShow = shouldShowParam;
    self.dialogRow = 1;
    self.dialogSection = 0;
    return self;
}

- (bool) show {
    NSObject* finished = [[NSUserDefaults standardUserDefaults] objectForKey:UD_FINISHED_KEY];
    NSObject* shown = [[NSUserDefaults standardUserDefaults] objectForKey:UD_SHOWN_KEY];
    return (shown != nil || shouldShow()) && finished == nil;
}

//Adjust indexPath for manipulating of table cell directrly in UITableViewController (bad decision)
- (NSIndexPath *) adjustIndexPath:(NSIndexPath *) indexPath {
   if (!self.show || indexPath.section != self.dialogSection || indexPath.row < self.dialogRow) {
       return indexPath;
   } else if (indexPath.row >= self.dialogRow) {
       return [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
   } else {
       //our rateme cell
       return nil;
   }
}

//Adjust indexPath for forward methods to delegate and datasource
- (NSIndexPath *) getForwardIndexPath:(NSIndexPath *) indexPath {
    if (!self.show || indexPath.section != self.dialogSection || indexPath.row < self.dialogRow) {
        return indexPath;
    } else if (indexPath.row >= self.dialogRow) {
        return [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    } else {
        //our rateme cell
        return nil;
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.wrappedDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.wrappedDataSource numberOfSectionsInTableView:tableView];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger baseCount = [self.wrappedDataSource tableView:tableView numberOfRowsInSection:section];
    if (self.show && (section == self.dialogSection) && (baseCount > self.dialogRow)) {
        baseCount++;
    }
    return baseCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.show || indexPath.section != self.dialogSection || indexPath.row < self.dialogRow) {
        return [self.wrappedDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    } else if (indexPath.row > self.dialogRow) {
        return [self.wrappedDataSource tableView:tableView
                           cellForRowAtIndexPath:[self getForwardIndexPath:indexPath]];
    } else {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TIRateMe" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        NSArray *topLevelObjects = [bundle loadNibNamed:@"TIRateMeCell" owner:self options:nil];
        TIRateMeCellTableViewCell* cell = [topLevelObjects objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;

        NSObject* shown = [[NSUserDefaults standardUserDefaults] objectForKey:UD_SHOWN_KEY];
        if (shown == nil) {
            [TIAnalytics.shared trackEvent:@"RATEME-CELL_SHOWN_FIRST"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:UD_SHOWN_KEY];
        
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.show || indexPath.section != self.dialogSection || indexPath.row != self.dialogRow) {
        return [self.wrappedDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return 95.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.show || indexPath.section != self.dialogSection || indexPath.row < self.dialogRow) {
        [self.wrappedDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else if (indexPath.row > self.dialogRow) {
        [self.tableView selectRowAtIndexPath:[self getForwardIndexPath:indexPath] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.wrappedDelegate tableView:tableView didSelectRowAtIndexPath:[self getForwardIndexPath:indexPath]];
    } else {
        //do nothing for rate me cell
    }
}

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.wrappedDelegate respondsToSelector:@selector(tableView: didHighlightRowAtIndexPath:)]) {
        [self.wrappedDelegate tableView:tableView didHighlightRowAtIndexPath:[self getForwardIndexPath:indexPath]];
    }
}

- (void) tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.wrappedDelegate respondsToSelector:@selector(tableView: didUnhighlightRowAtIndexPath:)]) {
        [self.wrappedDelegate tableView:tableView didUnhighlightRowAtIndexPath:[self getForwardIndexPath:indexPath]];
    }
}

#pragma mark TIRateMeDelegate
- (void) finished {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:UD_FINISHED_KEY];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dialogRow inSection:self.dialogSection]] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
}

- (void) animateTransition {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dialogRow inSection:self.dialogSection]] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void) sendToAppstore {
    [[UIApplication sharedApplication] openURL:self.appstoreURL];
}

- (void) askFeedback  {
    [self.feedbackObject askFeedbackWithVC:self.presentingVC doneCallback:nil];
}
@end
