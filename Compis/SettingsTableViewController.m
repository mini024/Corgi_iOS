//
//  SettingsTableViewController.m
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 4/24/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "ModeTableViewCell.h"
#import "WebViewController.h"

@interface SettingsTableViewController ()
@property NSArray* titles;
@property NSString *selected;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titles = [NSArray arrayWithObjects: @"Documentation", @"Language Manual", @"Demo Video", nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
      return 1;
    }
    return _titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ModeTableViewCell *cell = (ModeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ModeCell" forIndexPath:indexPath];
        
        cell.titleText = @"Night Mode";
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return indexPath;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Display";
    }
    return @"General";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        _selected = _titles[indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"documentation" sender:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqual: @"documentation"] && [_selected isEqualToString:@"Documentation"]) {
        WebViewController *destinationView = (WebViewController *) segue.destinationViewController;
        destinationView.webLink = @"https://docs.google.com/document/d/18CwlcTPGstcXR2paHTkDZ-xnOpVWU-GQ4Rv9tyxyFcI/edit?usp=sharing";
    } else if ([segue.identifier  isEqual: @"documentation"] && [_selected isEqualToString:@"Language Manual"]) {
        WebViewController *destinationView = (WebViewController *) segue.destinationViewController;
        destinationView.webLink = @"https://docs.google.com/document/d/1HlTYj911Bg2WraLhI8UeQP9tYgoCPf_TTbKJAjb8-mU/edit?usp=sharing";
    } else if ([segue.identifier  isEqual: @"documentation"] && [_selected isEqualToString:@"Demo Video"]) {
        WebViewController *destinationView = (WebViewController *) segue.destinationViewController;
        destinationView.webLink = @"https://drive.google.com/file/d/1_Ca3jahJO9MP6ZLlAn1sn_RkFVMmkxnb/view?usp=sharing";
    }
}


- (IBAction)modeChanged:(UISwitch*)sender {
    if (sender.isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"NightMode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"NightMode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
