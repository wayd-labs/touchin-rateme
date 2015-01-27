
TouchIn-RateMe
=========
Rate Me library for iOS apps helps you to push users to Rate your app in AppStore or to give you valuable feedback.

Original Idea: https://medium.com/circa/the-right-way-to-ask-users-to-review-your-app-9a32fd604fca


Install
=========
pod 'touchin-rateme', :git => 'https://github.com/TouchInstinct/touchin-rateme'


TIRateMeTableWrapper
=========

![](https://pbs.twimg.com/media/B3kHdVfCcAA1E_v.jpg)

    self.tableDataSource = [PodcastTableDataSource new];
    ratemeWrapper = [[TIRateMeTableWrapper alloc] initWithDataSource:self.tableDataSource tableDelegate:self
        shouldShow:^bool{ //show rate me cell only if true
            return true; 
    }];
    ratemeWrapper.dialogSection = 0; //default 0;
    ratemeWrapper.dialogRow = 1; //default 1
    ratemeWrapper.feedbackObject = [[TIEmailFeedback alloc] initWithEmail:@"hello@wayd.me"];; //For sending email if user don't like the app
    ratemeWrapper.presentingVC = self; //for presenting MFMailCompose
    ratemeWrapper.tableView = self.tableView; //for updating rows
    //to redirect to appstore if user likes the app
    ratemeWrapper.appstoreURL = [NSURL URLWithString:@"https://itunes.apple.com/app/radio-follow-me/id898764827"]; 
    //accurately wraps original datasource and wrapper
    self.tableView.dataSource = ratemeWrapper;
    self.tableView.delegate = ratemeWrapper;



TIEmailFeedback
=========
Show MFMailComposeViewController with some useful info about app and device

    TIEmailFeedback *feedback = [[TIEmailFeedback alloc] initWithEmail:@"followme@touchin.ru"];
    [feedback askFeedbackWithVC:self doneCallback:nil];
