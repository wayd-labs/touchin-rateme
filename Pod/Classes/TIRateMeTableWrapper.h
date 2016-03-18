//
//  TITableDataSourceWrapper.h
//  touchin-rateme
//
//  Created by Tony Larin on 09/01/15.
//
//

#import <Foundation/Foundation.h>
#import "touchin_trivia/TIEmailFeedback.h"
#import "touchin_trivia/TIAppearance.h"
#import "touchin_trivia/TITableWrapper.h"

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
