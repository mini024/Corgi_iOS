//
//  WebViewController.h
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 5/2/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic)  NSString *webLink;

@end
