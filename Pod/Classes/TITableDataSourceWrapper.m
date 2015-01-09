//
//  TITableDataSourceWrapper.m
//  touchin-rateme
//
//  Created by Tony Larin on 09/01/15.
//
//

#import "TITableDataSourceWrapper.h"

@implementation TITableDataSourceWrapper

int DIALOGROW = 1;

- (TITableDataSourceWrapper*) initWithDataSource:(id<UITableViewDataSource>) dataSource delegate:(id<UITableViewDelegate>) delegate {
    self = [super init];
    _wrappedDataSource = dataSource;
    _wrappedDelegate = delegate;
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger baseCount = [self.wrappedDataSource tableView:tableView numberOfRowsInSection:section];
    if (baseCount > DIALOGROW) {
        baseCount++;
    }
    return baseCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != DIALOGROW) {
        return [self.wrappedDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TIRateMe" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        NSArray *topLevelObjects = [bundle loadNibNamed:@"TIRateMeCell" owner:self options:nil];
        UITableViewCell* cell = [topLevelObjects objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != DIALOGROW) {
        return [self.wrappedDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return 95.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < DIALOGROW) {
        [self.wrappedDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else if (indexPath.row > DIALOGROW) {
        NSIndexPath* offsetPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        [self.wrappedDelegate tableView:tableView didSelectRowAtIndexPath:offsetPath];
    } else {
        //do nothing for rate me row
    }
}
@end
