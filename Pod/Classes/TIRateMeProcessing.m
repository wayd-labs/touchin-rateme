//
//  TIRateMeProcessing.m
//  Pods
//
//  Created by Aleksey Alekseenkov on 9/24/15.
//
//

#import "TIRateMeProcessing.h"
#import "TITrivia.h"
#import "TIAnalytics.h"

@interface TIRateMeProcessing()

@property (strong, nonatomic) NSMutableDictionary *yesButtonTitles;
@property (strong, nonatomic) NSMutableDictionary *noButtonTitles;
@property (strong, nonatomic) NSMutableDictionary *descriptions;

@end

NSString* UD_STAGE_KEY = @"TIRateMeStage";

@implementation TIRateMeProcessing

+ (instancetype)sharedInstance {
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  
  return sharedInstance;
}

#pragma mark - getter/setter

- (NSMutableDictionary *) yesButtonTitles {
    if (!_yesButtonTitles) {
        _yesButtonTitles = [NSMutableDictionary new];
    }
    return _yesButtonTitles;
}

- (NSMutableDictionary *) noButtonTitles {
    if (!_noButtonTitles) {
        _noButtonTitles = [NSMutableDictionary new];
    }
    return _noButtonTitles;
}

- (NSMutableDictionary *) descriptions {
    if (!_descriptions) {
        _descriptions = [NSMutableDictionary new];
    }
    return _descriptions;
}

#pragma mark - interface/logic

- (void) setYesButtonTitle:(NSString*) title forStage:(TIRateMeStage) stage {
    [self.yesButtonTitles setObject:title forKey:@(stage)];
}

- (NSString*) getYesButtonCurrentTitle {
    return [self.yesButtonTitles objectForKey:@([self getStage])];
}

- (void) setNoButtonTitle:(NSString*) title forStage:(TIRateMeStage) stage {
    [self.noButtonTitles setObject:title forKey:@(stage)];
}

- (NSString*) getNoButtonCurrentTitle {
    return [self.noButtonTitles objectForKey:@([self getStage])];
}

- (void) setDescription:(NSString*) description forStage:(TIRateMeStage) stage {
    [self.descriptions setObject:description forKey:@(stage)];
}

- (NSString*) getCurrentDescription {
    return [self.descriptions objectForKey:@([self getStage])];
}

- (TIRateMeStage) getStage {
    NSNumber* stage = [[NSUserDefaults standardUserDefaults] objectForKey:UD_STAGE_KEY];
    if (stage != nil) {
        return (TIRateMeStage) stage.integerValue;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:self.UD_SHOWN_KEY];
        return TIRateMeStageLike;
    }
}

- (NSString*) getStageName {
    TIRateMeStage stage = self.getStage;
    if (stage == TIRateMeStageLike) {
        return @"LIKE";
    }
    if (stage == TIRateMeStageAppStore) {
        return @"APPSTORE";
    }
    if (stage == TIRateMeStageFeedback) {
        return @"FEEDBACK";
    }
    return nil;
}

- (void) setStage:(TIRateMeStage) stage {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:stage] forKey:UD_STAGE_KEY];
}

- (void) yesButtonTap {
    if ([self getStage] == TIRateMeStageLike) {
        [TIAnalytics.shared trackEvent:@"RATEME_LIKE_ANSWERED" properties:@{@"answer": @"YES"}];
        [self setStage:TIRateMeStageAppStore];
    }
    else if ([self getStage] == TIRateMeStageAppStore) {
        [TIAnalytics.shared trackEvent:@"RATEME_APPSTORE_ANSWERED" properties:@{@"answer": @"YES"}];
        [self sendToAppstore];
        [self finish:TRUE];
    }
    else if ([self getStage] == TIRateMeStageFeedback) {
        [TIAnalytics.shared trackEvent:@"RATEME_FEEDBACK_ANSWERED" properties:@{@"answer": @"YES"}];
        [self askFeedback];
        [self finish:TRUE];
    }
}

- (void) noButtonTap {
    if ([self getStage] == TIRateMeStageLike) {
        [TIAnalytics.shared trackEvent:@"RATEME_LIKE_ANSWERED" properties:@{@"answer": @"NO"}];
        [self setStage:TIRateMeStageFeedback];
    }
    else {
        if ([self getStage] == TIRateMeStageAppStore) {
            [TIAnalytics.shared trackEvent:@"RATEME_APPSTORE_ANSWERED" properties:@{@"answer": @"NO"}];
        }
        else if ([self getStage] == TIRateMeStageFeedback) {
            [TIAnalytics.shared trackEvent:@"RATEME_FEEDBACK_ANSWERED" properties:@{@"answer": @"NO"}];
        }
        [self finish:FALSE];
    }
}

- (void) sendToAppstore {
    [[UIApplication sharedApplication] openURL:self.appstoreURL];
}

- (void) askFeedback  {
    [self.feedbackObject askFeedbackWithVC:self.presentingVC doneCallback:nil];
}

- (void) finish:(BOOL)positive {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:[self UD_FINISHED_KEY]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[self UD_FINISHED_DATE]];
    if (positive) {
        [[NSUserDefaults standardUserDefaults] setObject:TITrivia.appVersion forKey:[self UD_FINISHED_VERSION]];
    }
}

- (NSString*) UD_SHOWN_KEY {
    return [NSStringFromClass([self class]) stringByAppendingString:@"RateMeShown"];
}

- (NSString*) UD_FINISHED_KEY {
    return [NSStringFromClass([self class]) stringByAppendingString:@"RateMeFinished"];
}

- (NSString*) UD_FINISHED_DATE {
    return [NSStringFromClass([self class]) stringByAppendingString:@"RateMeFinishedDate"];
}

- (NSString*) UD_FINISHED_VERSION {
    return [NSStringFromClass([self class]) stringByAppendingString:@"RateMeFinishedVersion"];
}

- (BOOL) isFinished {
    NSNumber* value = [[NSUserDefaults standardUserDefaults] objectForKey:[self UD_FINISHED_KEY]];
    return value.boolValue;
}

- (BOOL) shouldShow {
    NSString* currentVersion = TITrivia.appVersion;
    NSDate* ratedDate = [[NSUserDefaults standardUserDefaults] objectForKey:[self UD_FINISHED_DATE]];
    NSString* ratedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:[self UD_FINISHED_VERSION]];
    BOOL shouldShow = ![self isFinished];
    if (ratedDate == nil) {
        return shouldShow;
    }
    BOOL isMonthPassed = FALSE;
    double days = [[NSDate date] timeIntervalSinceDate:ratedDate] / (3600 * 24);
    isMonthPassed = days > 30;
    BOOL isVersionUpdated = FALSE;
    if (ratedVersion != nil) {
        isVersionUpdated = [ratedVersion compare:currentVersion options:NSNumericSearch] == NSOrderedAscending;
        if (isVersionUpdated && isMonthPassed) {
            [self setStage:TIRateMeStageLike];
        }
        return isVersionUpdated && isMonthPassed;
    }
    else {
        if (isMonthPassed) {
            [self setStage:TIRateMeStageLike];
        }
        return isMonthPassed;
    }
    return shouldShow;
}

- (BOOL) shown {
    NSObject* _shown = [[NSUserDefaults standardUserDefaults] objectForKey:[self UD_SHOWN_KEY]];
    return ((NSNumber*)_shown).boolValue;
}

@end
