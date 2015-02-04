//
//  TIRateMeCellTableViewCell.m
//  touchin-rateme
//
//  Created by Толя Ларин on 09/01/15.
//
//
#import "TIRateMeCellTableViewCell.h"
#import "TIAnalytics.h"
#import "UIImage+TIImageAdditions.h"

@implementation TIRateMeCellTableViewCell

typedef enum {
    TIRateMeCellStageLike = 1,
    TIRateMeCellStageAppStore = 2,
    TIRateMeCellStageFeedback = 3,
} TIRateMeCellStage;

NSString* UD_STAGE_KEY = @"TIRateMeCellStage";

- (void) makeRoundCorneredFrame: (CALayer*) layer {
    layer.masksToBounds = TRUE;
    layer.cornerRadius = 5;
    layer.borderWidth = 1;
    layer.borderColor = self.appearance.accentColor.CGColor;
}

- (void) setUpButton: (UIButton*) button {
    [self makeRoundCorneredFrame:button.layer];
//    [button setTintColor:[UIColor whiteColor]];
    [button setTitleColor:self.appearance.accentColor forState:UIControlStateNormal];
    [button setTitleColor:self.appearance.backgroundColor forState:UIControlStateHighlighted];
    [button setTitleColor:self.appearance.backgroundColor forState:UIControlStateSelected];
    
    //for background change
    [button setBackgroundImage:[[UIImage imageWithColor:self.appearance.accentColor size:CGSizeMake(1.0, 1.0)] resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateHighlighted];
//    [button setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0] size:CGSizeMake(1.0, 1.0)] resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
//    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDragInside];
//    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
//    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
//    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchDragOutside];
}

- (void) buttonTouchDown:(id)sender
{
    UIButton* button = sender;
    [button setBackgroundColor:self.appearance.accentColor];
}

- (void) buttonTouchUp:(id)sender
{
    UIButton* button = sender;
    [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
}

- (void)awakeFromNib {
    [self.yesButton addTarget:self action:@selector(yesButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.noButton addTarget:self action:@selector(noButtonTap) forControlEvents:UIControlEventTouchUpInside];

    //todo move colors to properties sometime
    [self setBackgroundColor:self.appearance.backgroundColor];
    self.questionLabel.textColor = self.appearance.accentColor;
    
    [self setUpButton:self.yesButton];
    [self setUpButton:self.noButton];
    
    [self setUpStage:[self getStage]];
    
    [TIAnalytics.shared trackEvent:@"RATEME-CELL_STAGE_SHOWN" properties:@{@"stage": self.getStageName}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (TIRateMeCellStage) getStage {
    NSNumber* stage = [[NSUserDefaults standardUserDefaults] objectForKey:UD_STAGE_KEY];
    if (stage != nil) {
        return (TIRateMeCellStage) stage.integerValue;
    } else {
        return TIRateMeCellStageLike;
    }
}

- (NSString*) getStageName {
    TIRateMeCellStage stage = self.getStage;
    if (stage == TIRateMeCellStageLike) {
        return @"LIKE";
    }
    if (stage == TIRateMeCellStageAppStore) {
        return @"APPSTORE";
    }
    if (stage == TIRateMeCellStageFeedback) {
        return @"FEEDBACK";
    }
    return nil;
}

- (void) setStage:(TIRateMeCellStage) stage {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:stage] forKey:UD_STAGE_KEY];
}

- (void) setUpStage:(TIRateMeCellStage) stage {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TIRateMe" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (stage == TIRateMeCellStageLike) {
        [self.yesButton setTitle:[bundle localizedStringForKey:@"Like-Yes" value:@"" table:nil] forState:UIControlStateNormal];
        [self.noButton setTitle:[bundle localizedStringForKey:@"Like-No" value:@"" table:nil] forState:UIControlStateNormal];
        self.questionLabel.text = [bundle localizedStringForKey:@"Like-Question" value:@"" table:nil];
    }
    if (stage == TIRateMeCellStageAppStore) {
        [self.yesButton setTitle:[bundle localizedStringForKey:@"AppStore-Yes" value:@"" table:nil] forState:UIControlStateNormal];
        [self.noButton setTitle:[bundle localizedStringForKey:@"AppStore-No" value:@"" table:nil] forState:UIControlStateNormal];
        self.questionLabel.text = [bundle localizedStringForKey:@"AppStore-Question" value:@"" table:nil];
    }
    if (stage == TIRateMeCellStageFeedback) {
        [self.yesButton setTitle:[bundle localizedStringForKey:@"Feedback-Yes" value:@"" table:nil] forState:UIControlStateNormal];
        [self.noButton setTitle:[bundle localizedStringForKey:@"Feedback-No" value:@"" table:nil] forState:UIControlStateNormal];
        self.questionLabel.text = [bundle localizedStringForKey:@"Feedback-Question" value:@"" table:nil];
    }
}

- (void) yesButtonTap {
    TIRateMeCellStage stage = self.getStage;
    if (stage == TIRateMeCellStageLike) {
        [TIAnalytics.shared trackEvent:@"RATEME-CELL_LIKE_ANSWERED" properties:@{@"answer": @"YES"}];
        [self setStage:TIRateMeCellStageAppStore];
        [self.delegate animateTransition];
    } else {
        if (stage == TIRateMeCellStageAppStore) {
            [TIAnalytics.shared trackEvent:@"RATEME-CELL_APPSTORE_ANSWERED" properties:@{@"answer": @"YES"}];
            [self.delegate sendToAppstore];
        }
        if (stage == TIRateMeCellStageFeedback) {
            [TIAnalytics.shared trackEvent:@"RATEME-CELL_FEEDBACK_ANSWERED" properties:@{@"answer": @"YES"}];
            [self.delegate askFeedback];
        }
        [self.delegate finished];
    }
}

- (void) noButtonTap {
    if (self.getStage == TIRateMeCellStageLike) {
        [TIAnalytics.shared trackEvent:@"RATEME-CELL_LIKE_ANSWERED" properties:@{@"answer": @"NO"}];
        [self setStage:TIRateMeCellStageFeedback];
        [self.delegate animateTransition];
    } else {
        if (self.getStage == TIRateMeCellStageAppStore) {
            [TIAnalytics.shared trackEvent:@"RATEME-CELL_APPSTORE_ANSWERED" properties:@{@"answer": @"NO"}];
        }
        if (self.getStage == TIRateMeCellStageFeedback) {
            [TIAnalytics.shared trackEvent:@"RATEME-CELL_FEEDBACK_ANSWERED" properties:@{@"answer": @"NO"}];
        }
        
        [self.delegate finished];
    }
}

@end
