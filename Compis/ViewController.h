//
//  ViewController.h
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 2/14/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Program.h"


@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *consoleTextView;
@property (weak, nonatomic) Program *selectedProgram;
@property (weak, nonatomic) NSString *selectedCode;

- (IBAction)parseTextView:(id)sender;

@end

