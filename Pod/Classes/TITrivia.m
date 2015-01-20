//
//  TITrivia.m
//  followme
//
//  Created by Толя Ларин on 19/01/15.
//  Copyright (c) 2015 Толя Ларин. All rights reserved.
//

#import "TITrivia.h"

@implementation TITrivia

+ (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

+ (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self build];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@ (%@)", versionBuild, build];
    }
    
    return versionBuild;
}

+ (NSString *) appDisplayName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *) iosVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *) deviceModel
{
    return [[UIDevice currentDevice] model];
}
@end
