//
//  TITableDataSourceWrapper.h
//  touchin-rateme
//
//  Created by Tony Larin on 09/01/15.
//
//

#import <Foundation/Foundation.h>
#import "TIEmailFeedback.h"

@protocol TIRateMeDelegate
- (void) finished;
- (void) sendToAppstore;
- (void) askFeedback;
- (void) animateTransition;
@end

@interface TIRateMeTableWrapper : NSObject<UITableViewDataSource, UITableViewDelegate, TIRateMeDelegate>

@property (weak, readonly) id<UITableViewDataSource> wrappedDataSource;
@property (weak, readonly) id<UITableViewDelegate> wrappedDelegate;

@property NSUInteger dialogRow;
@property NSUInteger dialogSection;
@property TIEmailFeedback* feedbackObject;
@property (weak) UIViewController* presentingVC;
@property (weak) UITableView* tableView;
@property NSURL* appstoreURL;

- (TIRateMeTableWrapper*) initWithDataSource:(id<UITableViewDataSource>) dataSource
                      tableDelegate:(id<UITableViewDelegate>) delegate
                         shouldShow:(bool (^)(void))shouldShow;

- (NSIndexPath *) adjustIndexPath:(NSIndexPath *) indexPath;

@end
