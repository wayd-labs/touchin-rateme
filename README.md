
TouchIn-RateMe
=========
Rate Me library for iOS apps helps you to push users to Rate your app in AppStore or to give you valuable feedback.
Original Idea: https://medium.com/circa/the-right-way-to-ask-users-to-review-your-app-9a32fd604fca


Install
=========
pod 'touchin-rateme', :git => 'https://github.com/TouchInstinct/touchin-rateme'


TIRateMeTableWrapper
=========
self.tableDataSource = [PodcastTableDataSource new];
ratemeWrapper = [[TIRateMeTableWrapper alloc] initWithDataSource:self.tableDataSource tableDelegate:self
shouldShow:^bool{
return true;
}];
ratemeWrapper.dialogRow = 1;
ratemeWrapper.feedbackObject = [AboutViewController getEmailFeedbackInstance];
ratemeWrapper.presentingVC = self;
ratemeWrapper.tableView = self.tableView;
#pragma warning todo:take this one from bundle id
ratemeWrapper.appstoreURL = [NSURL URLWithString:@"https://itunes.apple.com/app/radio-follow-me/id898764827"];

self.tableView.dataSource = ratemeWrapper;
self.tableView.delegate = ratemeWrapper;



TIEmailFeedback
=========
TIEmailFeedback *feedback = [[TIEmailFeedback alloc] initWithEmail:@"followme@touchin.ru"];
[feedback askFeedbackWithVC:self doneCallback:nil];
