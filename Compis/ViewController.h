//
//  ViewController.h
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 2/14/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *corgiWeb;

- (IBAction)parseTextView:(id)sender;

@end

