//
//  TIRateMeProcessing.h
//  Pods
//
//  Created by Aleksey Alekseenkov on 9/24/15.
//
//

#import <Foundation/Foundation.h>
#import "TIEmailFeedback.h"

typedef enum {
    TIRateMeStageLike = 1,
    TIRateMeStageAppStore = 2,
    TIRateMeStageFeedback = 3,
} TIRateMeStage;

@interface TIRateMeProcessing : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) TIEmailFeedback* feedbackObject;
@property (strong, nonatomic) NSURL* appstoreURL;
@property (strong, nonatomic) UIViewController* presentingVC;

- (BOOL) shouldShow;

- (TIRateMeStage) getStage;
- (NSString*) getStageName;

- (NSString*) getYesButtonCurrentTitle;
- (NSString*) getNoButtonCurrentTitle;
- (NSString*) getCurrentDescription;

- (void) yesButtonTap;
- (void) noButtonTap;

- (void) setYesButtonTitle:(NSString*) title forStage:(TIRateMeStage) stage;
- (void) setNoButtonTitle:(NSString*) title forStage:(TIRateMeStage) stage;
- (void) setDescription:(NSString*)description forStage:(TIRateMeStage) stage;

@end
