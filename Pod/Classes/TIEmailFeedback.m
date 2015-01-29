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
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TIRateMe" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:@[email]];
        NSString* subject = [bundle localizedStringForKey:@"[%@] Feedback" value:@"" table:nil];
        [controller setSubject:[NSString stringWithFormat:subject, TITrivia.appDisplayName]];
        [controller setMessageBody:self.getFooter isHTML:NO];
        [presentingVC presentViewController:controller animated:YES completion:nil];
    } else {
        NSString* title = [bundle localizedStringForKey:@"Mail account is not configured" value:@"" table:nil];
        NSString* message = [NSString stringWithFormat:[bundle localizedStringForKey:@"Send us an email to %@" value:@"" table:nil], email];
        
        if([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * closeAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [presentingVC dismissViewControllerAnimated:TRUE completion:nil];
            }];
            [alert addAction:closeAction];
            [presentingVC presentViewController:alert animated:TRUE completion:nil];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
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
