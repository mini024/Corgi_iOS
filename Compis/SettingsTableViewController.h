//
//  SettingsTableViewController.h
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 4/24/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISwitch *nightModeSwitch;
- (IBAction)modeChanged:(UISwitch*)sender;

@end
