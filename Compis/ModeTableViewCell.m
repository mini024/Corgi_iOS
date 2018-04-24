//
//  ModeTableViewCell.m
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 4/24/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "ModeTableViewCell.h"

@implementation ModeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nightModeSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NightMode"] isEqual: @"true"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

@end
