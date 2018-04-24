//
//  ConsoleViewController.m
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 4/20/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "ConsoleViewController.h"
#import "ColorPalette.h"


@interface ConsoleViewController ()

@end

@implementation ConsoleViewController
@synthesize consoleText;
@synthesize consoleTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (consoleText != nil) {
        consoleTextView.text = consoleText;
    }
    
    consoleTextView.backgroundColor = ColorPalette.outputBackgroundColor;
    consoleTextView.textColor = ColorPalette.outputTextColor;
}

- (void)viewDidAppear:(BOOL)animated {
    if (consoleText != nil) {
        consoleTextView.text = consoleText;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
