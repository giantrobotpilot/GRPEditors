//
//  MainTableViewController.h
//  GRPEditors
//
//  Created by Drew on 2/22/11.
//  Copyright 2011 Giant Robot Pilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRPTextViewEditor.h"
#import "GRPTextEditor.h"

@interface MainTableViewController : UITableViewController <GRPTextEditorDelegate, GRPTextViewEditorDeletage> {

}

@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)context;
-(void)GRPTextEditorDidReturnText:(NSString *)text;

@end
