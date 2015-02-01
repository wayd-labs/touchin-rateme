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

- (UITableViewCell*) createServiceCell {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TIRateMe" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSArray *topLevelObjects = [bundle loadNibNamed:@"TIRateMeCell" owner:self options:nil];
    TIRateMeCellTableViewCell* cell = [topLevelObjects objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.appearance = self.appearance? self.appearance : TIAppearance.mintAppearance;
    [cell awakeFromNib];
    cell.delegate = self;
    
    return cell;
}

#pragma mark TIRateMeDelegate
- (void) sendToAppstore {
    [[UIApplication sharedApplication] openURL:self.appstoreURL];
}

- (void) askFeedback  {
    [self.feedbackObject askFeedbackWithVC:self.presentingVC doneCallback:nil];
}
@end
