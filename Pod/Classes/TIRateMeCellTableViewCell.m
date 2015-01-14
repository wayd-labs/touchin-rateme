//
//  TIRateMeCellTableViewCell.m
//  touchin-rateme
//
//  Created by Толя Ларин on 09/01/15.
//
//
#import "TIRateMeCellTableViewCell.h"

@implementation TIRateMeCellTableViewCell

typedef enum {
    TIRateMeCellStageLike = 1,
    TIRateMeCellStageAppStore = 2,
    TIRateMeCellStageFeedback = 3,
} TIRateMeCellStage;

NSString* UD_STAGE_KEY = @"TIRateMeCellStage";

- (void)awakeFromNib {
    [self.yesButton addTarget:self action:@selector(yesButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.noButton addTarget:self action:@selector(noButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self setUpStage:[self getStage]];
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

- (void) setStage:(TIRateMeCellStage) stage {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:stage] forKey:UD_STAGE_KEY];
}

- (void) setUpStage:(TIRateMeCellStage) stage {
    [self setStage:stage];
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
        [self.yesButton setTitle:[bundle localizedStringForKey:@"Review-Yes" value:@"" table:nil] forState:UIControlStateNormal];
        [self.noButton setTitle:[bundle localizedStringForKey:@"Review-No" value:@"" table:nil] forState:UIControlStateNormal];
        self.questionLabel.text = [bundle localizedStringForKey:@"Review-Question" value:@"" table:nil];
    }
}

- (void) yesButtonTap {
    TIRateMeCellStage stage = self.getStage;
    if (stage == TIRateMeCellStageLike) {
        [self setUpStage:TIRateMeCellStageAppStore];
    } else {
        if (stage == TIRateMeCellStageAppStore) {
            [self sendToAppstore];
        }
        if (stage == TIRateMeCellStageFeedback) {
//            [self presentMail]
        }
        [self.delegate finished];
    }
}


- (void) noButtonTap {
    if (self.getStage == TIRateMeCellStageLike) {
        [self setUpStage:TIRateMeCellStageFeedback];
    } else {
        [self.delegate finished];
    }
}

#pragma mark Should move to some kind of delegate
- (void) sendToAppstore {
    [[UIApplication sharedApplication] openURL:self.appstoreURL];
}

@end
