//
//  TITableDataSourceWrapper.h
//  touchin-rateme
//
//  Created by Tony Larin on 09/01/15.
//
//

#import <Foundation/Foundation.h>
#import "TIEmailFeedback.h"
#import "TIAppearance.h"
#import "TITableWrapper.h"

@protocol TIRateMeDelegate
- (void) finished;
- (void) sendToAppstore;
- (void) askFeedback;
- (void) animateTransition;
@end

@interface TIRateMeTableWrapper : TITableWrapper <UITableViewDataSource, UITableViewDelegate, TIRateMeDelegate>

@property TIEmailFeedback* feedbackObject;
@property NSURL* appstoreURL;

@end
