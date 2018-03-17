//
//  ViewController.m
//  Compis
//
//  Created by Jessica M Cavazos Erhard on 2/14/18.
//  Copyright © 2018 Jessica M Cavazos Erhard. All rights reserved.
//

#import "ViewController.h"
#import "Compis-Swift.h"

#import "y.tab.h"
#import "DataBridge.h"

@interface ViewController ()
@property bool failed;
@property NSString* errors;
@end

@implementation ViewController
@synthesize textView;
@synthesize corgiWeb;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    textView.text = @"corgi test ;corgiRun() {  a = 5 + 6; }";
    
    [corgiWeb loadHTMLString:@"https://media.giphy.com/media/Wj7lNjMNDxSmc/giphy.gif" baseURL:[NSURL URLWithString:@"https://media.giphy.com/media/Wj7lNjMNDxSmc/giphy.gif"]];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://media.giphy.com/media/Wj7lNjMNDxSmc/giphy.gif"]];
    [corgiWeb loadData:data MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@"https://media.giphy.com/media/Wj7lNjMNDxSmc/giphy.gif"]];
    [corgiWeb scalesPageToFit];
    //[corgiWeb contentMode:UIViewContentModeScaleAspectFit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)parseTextView:(id)sender
{
    YY_BUFFER_STATE buf;
    _failed = false;
    _errors = @"";
    
    
    buf = yy_scan_string([self.textView.text cStringUsingEncoding:NSUTF8StringEncoding]);
    
    ParseTestSuccessBlock = ^(NSString *value) {
        if (!self.failed) {
            textView.text = value;
        }
    };
    
    ParseTestFailBlock = ^(NSString *msg) {
        self.failed = true;
        _errors = [_errors stringByAppendingString:msg];
        textView.text = _errors;
    };
    
    addVariableBlock = ^(NSString *name, NSString *type) {
        [Helper.singleton addVariable:name type: type];
    };
    
    addFunctionBlock = ^(NSString *name, NSString *type) {
        [Helper.singleton addFunction:name type: type];
    };
    
    findFunctionBlock = ^(NSString *value) {
        return [Helper.singleton functionExists:value];
    };
    
    findVariableBlock = ^(NSString *value) {
        return [Helper.singleton variableExists:value];
    };
    
    addIdToStackBlock = ^(NSString *name, NSString *type) {
        [Helper.singleton pushId:name type:type];
    };
    
    addOperatorToStackBlock = ^(NSString *val) {
        [Helper.singleton pushOperator:val];
    };
    
    checkNextOperatorBlock = ^(NSString *type) {
        NSString *nextOperator = [Helper.singleton getNextOp];
        bool isNextExp = [nextOperator isEqual: @"+"] || [nextOperator  isEqual: @"-"];
        bool isNextTerm = [nextOperator isEqual: @"/"] || [nextOperator  isEqual: @"*"] || [nextOperator  isEqual: @"^"] || [nextOperator  isEqual: @"%"];
         bool isNextRelation = [nextOperator isEqual: @"<"] || [nextOperator  isEqual: @">"] || [nextOperator  isEqual: @"<="] || [nextOperator  isEqual: @">="] || [nextOperator  isEqual: @"!="] || [nextOperator  isEqual: @"=="];
        
        if ([type isEqual: @"exp"] && isNextExp) {
            [Helper.singleton generateQuadruple];
        } else if ([type  isEqual: @"term"] && isNextTerm) {
            [Helper.singleton generateQuadruple];
        } else if ([type  isEqual: @"relational"] && isNextRelation) {
            [Helper.singleton generateQuadruple];
        }
    };
    
    deleteParentesisFromStackBlock = ^() {
        [Helper.singleton popPar];
    };
    
    yyparse();
    
    yy_delete_buffer(buf);
}

@end
