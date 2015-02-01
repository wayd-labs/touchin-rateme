//
//  TIAppearance.m
//  Pods
//
//  Created by Tony Larin on 30/01/15.
//
//

#import "TIAppearance.h"

@implementation TIAppearance

+ (TIAppearance*) blackAppearance {
    return [self apperanceWithBackgroundColor:[UIColor blackColor] accentColor:[UIColor whiteColor]];
}

+ (TIAppearance*) mintAppearance {
    return [self apperanceWithBackgroundColor:[UIColor colorWithRed:0 green:0.788 blue:0.659 alpha:1.0] accentColor:[UIColor whiteColor]];
}

+ (TIAppearance*) apperanceWithBackgroundColor:(UIColor*) background accentColor:(UIColor*) accent {
    TIAppearance* apperance = [TIAppearance new];
    apperance.backgroundColor = background;
    apperance.accentColor = accent;
    return apperance;
}

@end
