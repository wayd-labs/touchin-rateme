//
//  TIRateMeCellTableViewCell.h
//  touchin-rateme
//
//  Created by Толя Ларин on 09/01/15.
//
//

#import <UIKit/UIKit.h>

@interface TIRateMeCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end
