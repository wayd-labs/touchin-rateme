//
//  TITableDataSourceWrapper.m
//  touchin-rateme
//
//  Created by Tony Larin on 09/01/15.
//
//

#import "TIRateMeTableWrapper.h"
#import "TIRateMeCellTableViewCell.h"

@implementation TIRateMeTableWrapper

int DIALOGROW = 1;
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
    return self;
}

- (bool) show {
    NSObject* finished = [[NSUserDefaults standardUserDefaults] objectForKey:UD_FINISHED_KEY];
    NSObject* shown = [[NSUserDefaults standardUserDefaults] objectForKey:UD_SHOWN_KEY];
    return (shown != nil || shouldShow()) && finished == nil;
}

#pragma mark TIRateMeDelegate
- (void) finished {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:UD_FINISHED_KEY];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger baseCount = [self.wrappedDataSource tableView:tableView numberOfRowsInSection:section];
    if (self.show && (baseCount > DIALOGROW)) {
        baseCount++;
    }
    return baseCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.show || indexPath.row != DIALOGROW) {
        return [self.wrappedDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TIRateMe" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        NSArray *topLevelObjects = [bundle loadNibNamed:@"TIRateMeCell" owner:self options:nil];
        TIRateMeCellTableViewCell* cell = [topLevelObjects objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;

        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:UD_SHOWN_KEY];
        
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.show || indexPath.row != DIALOGROW) {
        return [self.wrappedDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return 95.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.show || indexPath.row < DIALOGROW) {
        [self.wrappedDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else if (indexPath.row > DIALOGROW) {
        NSIndexPath* offsetPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        [self.wrappedDelegate tableView:tableView didSelectRowAtIndexPath:offsetPath];
    } else {
        //do nothing for rate me row
    }
}
@end
