//
//  ConsoleViewController.h
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 4/20/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *consoleTextView;

@property (weak, nonatomic) NSString *consoleText;

@end
