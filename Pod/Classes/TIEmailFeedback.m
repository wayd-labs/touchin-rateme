//
//  TIFeedback.m
//  followme
//
//  Created by Толя Ларин on 19/01/15.
//  Copyright (c) 2015 Толя Ларин. All rights reserved.
//

#import "TIEmailFeedback.h"
#import "TITrivia.h"

@implementation TIEmailFeedback

NSString* email;
__weak UIViewController* presentingVC;
void (^doneCallback)(MFMailComposeResult);

- (TIEmailFeedback*) initWithEmail:(NSString*) email_ {
    self = [super init];
    email = email_;
    return self;
}

- (NSString*) getFooter {
    return [NSString stringWithFormat:@"\n\n\n\n----\n bundle id: %@\nversion: %@\ndevice: %@\nios: %@",
            [[NSBundle mainBundle] bundleIdentifier], TITrivia.versionBuild, TITrivia.deviceModel, TITrivia.iosVersion];
}

- (void) askFeedbackWithVC:(UIViewController*) presentingVC_ doneCallback:(void (^)(MFMailComposeResult))doneCallback_ {
    presentingVC = presentingVC_;
    doneCallback = doneCallback_;
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:@[email]];
        [controller setSubject:[NSString stringWithFormat:@"[%@] Пожелание или ошибка", TITrivia.appDisplayName]];
        [controller setMessageBody:self.getFooter isHTML:NO];
        [presentingVC presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Почта не настроена"
                                                        message:[NSString stringWithFormat:@"Отправьте нам письмо на %@", email]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    [presentingVC dismissViewControllerAnimated:YES completion:nil];
    if (doneCallback) {
        doneCallback(result);
    }
}

@end
