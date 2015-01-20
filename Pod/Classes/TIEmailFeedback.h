//
//  TIFeedback.h
//  followme
//
//  Created by Толя Ларин on 19/01/15.
//  Copyright (c) 2015 Толя Ларин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface TIEmailFeedback : NSObject<MFMailComposeViewControllerDelegate>

- (TIEmailFeedback*) initWithEmail:(NSString*) email;
- (void) askFeedbackWithVC:(UIViewController*) presentingVC doneCallback:(void (^)(MFMailComposeResult))doneCallback;

@end
