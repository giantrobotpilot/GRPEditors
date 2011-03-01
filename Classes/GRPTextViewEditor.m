//
//  TextViewViewController.m
//  TextView Test
//
//  Created by Andrew Christensen on 2/23/10.
//  Copyright 2010 Giant Robot Pilot. All rights reserved.
//

#import "GRPTextViewEditor.h"


@implementation GRPTextViewEditor

@synthesize allowBlank;
@synthesize textView;
@synthesize value;
@synthesize delegate;


- (void)dealloc {
    [value release];
    [textView release];

    [super dealloc];
}

-(id)initWithText:(NSString *)text {
    if ((self = [super initWithNibName:@"GRPTextViewEditor" bundle:nil])) {
        self.value = text;
    }
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(save)];
    
    
    self.textView.text = self.value;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self.textView becomeFirstResponder];
}

-(void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save {
    NSString *textValue = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!self.allowBlank && [textValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:BLANK_TEXTVIEW_TITLE
                                                        message:BLANK_TEXTVIEW_MESSAGE
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    } 
    else {
        [delegate GRPTextViewEditorDidReturnText:textValue];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
