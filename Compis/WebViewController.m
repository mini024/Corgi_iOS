//
//  WebViewController.m
//  CorgiCode
//
//  Created by Jessica M Cavazos Erhard on 5/2/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property WKWebView *webView;
@end

@implementation WebViewController
@synthesize webLink;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (webLink == nil) {
        webLink = @"https://youtu.be/4uJMhelaPFs";
    }
    // Do any additional setup after loading the view.
    NSURL *myURL = [[NSURL alloc] initWithString:webLink];
    NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:myURL];
    
    [self.webView loadRequest:myRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    //let webConfiguration = WKWebViewConfiguration()
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration alloc];
    webConfiguration.allowsInlineMediaPlayback = YES;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfiguration];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.view = _webView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
