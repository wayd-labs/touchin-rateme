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
    return self;
}

- (bool) show {
    NSObject* finished = [[NSUserDefaults standardUserDefaults] objectForKey:UD_FINISHED_KEY];
    NSObject* shown = [[NSUserDefaults standardUserDefaults] objectForKey:UD_SHOWN_KEY];
    return (shown != nil || shouldShow()) && finished == nil;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger baseCount = [self.wrappedDataSource tableView:tableView numberOfRowsInSection:section];
    if (self.show && (baseCount > self.dialogRow)) {
        baseCount++;
    }
    return baseCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.show || indexPath.row < self.dialogRow) {
        return [self.wrappedDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    } else if (indexPath.row > self.dialogRow) {
        NSIndexPath* offsetPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        return [self.wrappedDataSource tableView:tableView cellForRowAtIndexPath:offsetPath];
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
    if (!self.show || indexPath.row != self.dialogRow) {
        return [self.wrappedDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return 95.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.show || indexPath.row < self.dialogRow) {
        [self.wrappedDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else if (indexPath.row > self.dialogRow) {
        NSIndexPath* offsetPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        [self.tableView selectRowAtIndexPath:offsetPath animated:NO scrollPosition:UITableViewRowAnimationNone];
        [self.wrappedDelegate tableView:tableView didSelectRowAtIndexPath:offsetPath];
    } else {
        //do nothing for rate me cell
    }
}

#pragma mark TIRateMeDelegate
- (void) finished {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:UD_FINISHED_KEY];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dialogRow inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
}

- (void) animateTransition {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dialogRow inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void) sendToAppstore {
    [[UIApplication sharedApplication] openURL:self.appstoreURL];
}

- (void) askFeedback  {
    [self.feedbackObject askFeedbackWithVC:self.presentingVC doneCallback:nil];
}
@end
