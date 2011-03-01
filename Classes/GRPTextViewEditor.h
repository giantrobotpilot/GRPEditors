//
//  TextViewViewController.h
//  TextView Test
//
//  Created by Andrew Christensen on 2/23/10.
//  Copyright 2010 Giant Robot Pilot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GRPTextViewEditorDeletage

-(void)GRPTextViewEditorDidReturnText:(NSString *)text;

@end


@interface GRPTextViewEditor : UIViewController 
{
    BOOL allowBlank;
    id delegate;
    NSString *value;
    IBOutlet UITextView *textView;
}

@property (assign) BOOL allowBlank;
@property (assign) id delegate;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) UITextView *textView;

#define BLANK_TEXTVIEW_TITLE   @"Blank Title"
#define BLANK_TEXTVIEW_MESSAGE @"Blank Message"
@end
