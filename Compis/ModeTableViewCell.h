//
//  ModeTableViewCell.h
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 4/24/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) NSString *titleText;
@property (weak, nonatomic) IBOutlet UISwitch *nightModeSwitch;

- (void) setTitleText:(NSString *)titleText;

@end
