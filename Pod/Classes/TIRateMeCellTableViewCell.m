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
    TIRateMeCellStageReview = 3,
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
        self.yesButton.titleLabel.text = [bundle localizedStringForKey:@"Like-Yes" value:@"" table:nil];
        self.noButton.titleLabel.text = [bundle localizedStringForKey:@"Like-No" value:@"" table:nil];
        self.questionLabel.text = [bundle localizedStringForKey:@"Like-Question" value:@"" table:nil];
    }
    if (stage == TIRateMeCellStageAppStore) {
        self.yesButton.titleLabel.text = [bundle localizedStringForKey:@"AppStore-Yes" value:@"" table:nil];
        self.noButton.titleLabel.text = [bundle localizedStringForKey:@"AppStore-No" value:@"" table:nil];
        self.questionLabel.text = [bundle localizedStringForKey:@"AppStore-Question" value:@"" table:nil];
    }
    if (stage == TIRateMeCellStageReview) {
        self.yesButton.titleLabel.text = [bundle localizedStringForKey:@"Review-Yes" value:@"" table:nil];
        self.noButton.titleLabel.text = [bundle localizedStringForKey:@"Review-No" value:@"" table:nil];
        self.questionLabel.text = [bundle localizedStringForKey:@"Review-Question" value:@"" table:nil];
    }
}

- (void) yesButtonTap {
    if (self.getStage == TIRateMeCellStageLike) {
        [self setUpStage:TIRateMeCellStageAppStore];
    }
}

- (void) noButtonTap {
    if (self.getStage == TIRateMeCellStageLike) {
        [self setUpStage:TIRateMeCellStageReview];
    }
}

@end
