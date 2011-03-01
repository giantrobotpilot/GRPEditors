//
//  StyleEditViewController.h
//  BrewTour CO
//
//  Created by Andrew Christensen on 2/18/10.
//  Copyright 2010 Giant Robot Pilot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GRPCoreDataListChooserDelegate

-(void)GRPCoreDataListChooserDelegateDidReturnChoice:(NSString *)choice;

@end

@interface GRPCoreDataListChooser : UITableViewController <UITextFieldDelegate>
{
    NSArray *choicesArray;    
    NSString *chosenValue;
    id <GRPCoreDataListChooserDelegate> delegate;
    NSString *entityName;
    UITextField *textField;
    BOOL textSelected;
    NSManagedObjectContext *managedObjectContext;
    NSString *propertyName;
}

@property (assign) id <GRPCoreDataListChooserDelegate> delegate;
@property (nonatomic, retain) NSArray *choicesArray;
@property (nonatomic, retain) NSString *chosenValue;
@property (nonatomic, retain) NSString *entityName;
@property (nonatomic, retain) UITextField *textField;
@property BOOL textSelected;
@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *propertyName;

-(id)initWithProperty:(NSString *)propertyName inEntity:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)iContext chosenValue:(NSString *)chosen;
//-(id)initWithManagedObjectContext:(NSManagedObjectContext *)iContext  chosenValue:(NSString *)chosen;
-(void)populateChoicesArray;
-(void)addNewListObject;

// UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
