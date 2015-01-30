//
//  TIAppearance.h
//  Pods
//
//  Created by Толя Ларин on 30/01/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TIAppearance : NSObject

+ (TIAppearance*) apperanceWithBackgroundColor:(UIColor*) background accentColor:(UIColor*) accent;
+ (TIAppearance*) mintApperance;
+ (TIAppearance*) blackApperance;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *accentColor;


@end
