//
//  TIRateMeCellTableViewCell.h
//  touchin-rateme
//
//  Created by Толя Ларин on 09/01/15.
//
//

#import <UIKit/UIKit.h>
#import "TIRateMeTableWrapper.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "TIAppearance.h"

@interface TIRateMeCellTableViewCell : UITableViewCell<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (strong, nonatomic) TIAppearance *appearance;
@property (weak) id delegate;

@end
