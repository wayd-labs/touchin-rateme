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
#import "TIRateMeProcessing.h"

@interface TIRateMeCellTableViewCell()

@property (strong, nonatomic) TIRateMeProcessing * rateMeProcessing;

@end

@implementation TIRateMeCellTableViewCell

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
    self.rateMeProcessing = [TIRateMeProcessing new];
    [self setupTexts];
    
    [self.yesButton addTarget:self action:@selector(yesButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.noButton addTarget:self action:@selector(noButtonTap) forControlEvents:UIControlEventTouchUpInside];

    //todo move colors to properties sometime
    [self setBackgroundColor:self.appearance.backgroundColor];
    self.questionLabel.textColor = self.appearance.accentColor;
    
    [self setUpButton:self.yesButton];
    [self setUpButton:self.noButton];
    
    [self setUpStage];
    
    [TIAnalytics.shared trackEvent:@"RATEME-CELL_STAGE_SHOWN" properties:@{@"stage": [self.rateMeProcessing getStageName]}];
}

- (void) setupTexts {
    NSString *bundlePath = [[NSBundle bundleForClass:[TIRateMeCellTableViewCell class]] pathForResource:@"TIRateMe" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    [self.rateMeProcessing setYesButtonTitle:[bundle localizedStringForKey:@"Like-Yes" value:@"" table:nil] forStage:TIRateMeStageLike];
    [self.rateMeProcessing setYesButtonTitle:[bundle localizedStringForKey:@"AppStore-Yes" value:@"" table:nil] forStage:TIRateMeStageAppStore];
    [self.rateMeProcessing setYesButtonTitle:[bundle localizedStringForKey:@"Feedback-Yes" value:@"" table:nil] forStage:TIRateMeStageFeedback];
    
    [self.rateMeProcessing setNoButtonTitle:[bundle localizedStringForKey:@"Like-No" value:@"" table:nil] forStage:TIRateMeStageLike];
    [self.rateMeProcessing setNoButtonTitle:[bundle localizedStringForKey:@"AppStore-No" value:@"" table:nil] forStage:TIRateMeStageAppStore];
    [self.rateMeProcessing setNoButtonTitle:[bundle localizedStringForKey:@"Feedback-No" value:@"" table:nil] forStage:TIRateMeStageFeedback];
    
    [self.rateMeProcessing setDescription:[bundle localizedStringForKey:@"Like-Question" value:@"" table:nil] forStage:TIRateMeStageLike];
    [self.rateMeProcessing setDescription:[bundle localizedStringForKey:@"AppStore-Question" value:@"" table:nil] forStage:TIRateMeStageAppStore];
    [self.rateMeProcessing setDescription:[bundle localizedStringForKey:@"Feedback-Question" value:@"" table:nil] forStage:TIRateMeStageFeedback];
}

- (void) setUpStage {
    [self.yesButton setTitle:[self.rateMeProcessing getYesButtonCurrentTitle] forState:UIControlStateNormal];
    [self.noButton setTitle:[self.rateMeProcessing getNoButtonCurrentTitle] forState:UIControlStateNormal];
    self.questionLabel.text = [self.rateMeProcessing getCurrentDescription];
}

- (void) yesButtonTap {
    TIRateMeStage stage = [self.rateMeProcessing getStage];
    if (stage == TIRateMeStageLike) {
        [TIAnalytics.shared trackEvent:@"RATEME-CELL_LIKE_ANSWERED" properties:@{@"answer": @"YES"}];
        [self.delegate animateTransition];
    } else {
        if (stage == TIRateMeStageAppStore) {
            [TIAnalytics.shared trackEvent:@"RATEME-CELL_APPSTORE_ANSWERED" properties:@{@"answer": @"YES"}];
            [self.delegate sendToAppstore];
        }
        if (stage == TIRateMeStageFeedback) {
            [TIAnalytics.shared trackEvent:@"RATEME-CELL_FEEDBACK_ANSWERED" properties:@{@"answer": @"YES"}];
            [self.delegate askFeedback];
        }
        [self.delegate finished];
    }
    [self.rateMeProcessing yesButtonTap];
}

- (void) noButtonTap {
    TIRateMeStage stage = [self.rateMeProcessing getStage];
    if (stage == TIRateMeStageLike) {
        [TIAnalytics.shared trackEvent:@"RATEME-CELL_LIKE_ANSWERED" properties:@{@"answer": @"NO"}];
        [self.delegate animateTransition];
    } else {
        if (stage == TIRateMeStageAppStore) {
            [TIAnalytics.shared trackEvent:@"RATEME-CELL_APPSTORE_ANSWERED" properties:@{@"answer": @"NO"}];
        }
        if (stage == TIRateMeStageFeedback) {
            [TIAnalytics.shared trackEvent:@"RATEME-CELL_FEEDBACK_ANSWERED" properties:@{@"answer": @"NO"}];
        }
        
        [self.delegate finished];
    }
    [self.rateMeProcessing noButtonTap];
}

@end
