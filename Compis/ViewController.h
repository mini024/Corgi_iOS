//
//  ViewController.h
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 2/14/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Program.h"
#import "QEDTextView.h"


@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (retain, nonatomic) QEDTextView *codeTextView;
@property (weak, nonatomic) Program *selectedProgram;
@property (weak, nonatomic) NSString *selectedCode;

- (IBAction)parseTextView:(id)sender;
- (IBAction)saveCode:(id)sender;

@end

