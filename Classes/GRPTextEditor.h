//
//  RatingTextEditController.h
//  BrewTour CO
//
//  Created by Andrew Christensen on 2/18/10.
//  Copyright 2010 Giant Robot Pilot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GRPTextEditorDelegate

-(void)GRPTextEditorDidReturnText:(NSString *)text;

@end


@interface GRPTextEditor : UITableViewController <UITextFieldDelegate>
{
    BOOL allowBlank;
    id <GRPTextEditorDelegate> delegate;
    NSString *value;
    UITextField *textField;
}

@property (assign) BOOL allowBlank;
@property (assign) id <GRPTextEditorDelegate> delegate;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, copy) NSString *value;

-(id)initWithText:(NSString *)text;

#define BLANK_FIELD_TITLE   @"Blank Field"
#define BLANK_FIELD_MESSAGE @"Please enter some text"

@end
