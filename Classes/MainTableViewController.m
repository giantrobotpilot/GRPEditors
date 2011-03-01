//
//  MainTableViewController.m
//  GRPEditors
//
//  Created by Drew on 2/22/11.
//  Copyright 2011 Giant Robot Pilot. All rights reserved.
//

#import "MainTableViewController.h"
#import "GRPTextEditor.h"
#import "GRPTextViewEditor.h"
#import "GRPCoreDataListChooser.h"

@implementation MainTableViewController

@synthesize managedObjectContext;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.managedObjectContext = context;
    }
    return self;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Text Editor";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Core Data Chooser";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"TextView Editor";
    } else {
        cell.textLabel.text = @"Array Chooser";
    }

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    if (indexPath.row == 0) {
        GRPTextEditor *textEditor = [[GRPTextEditor alloc] initWithText:@"Frequency"];
        textEditor.delegate = self;
        textEditor.allowBlank = YES;
        //textEditor.title = @"Let's Go!";
        [self.navigationController pushViewController:textEditor animated:YES];
        [textEditor release];
    } 
    else if (indexPath.row == 2) {
        GRPTextViewEditor *textViewEditor = [[GRPTextViewEditor alloc] initWithText:@"HI"];
        textViewEditor.delegate = self;
        textViewEditor.title = @"Write some Text!";
        textViewEditor.allowBlank = NO;
        [self.navigationController pushViewController:textViewEditor animated:YES];
        [textViewEditor release];
    } else {
        GRPCoreDataListChooser *chooser = [[GRPCoreDataListChooser alloc] initWithProperty:@"Name" inEntity:@"Group" inManagedObjectContext:self.managedObjectContext chosenValue:nil];
        chooser.delegate = self;
        [self.navigationController pushViewController:chooser animated:YES];
        [chooser release];
    }

}

-(void)GRPTextEditorDidReturnText:(NSString *)text {
    NSLog(@"%@", text);
}

-(void)GRPTextViewEditorDidReturnText:(NSString *)text {
    NSLog(@"%@", text);
}

-(void)GRPCoreDataListChooserDelegateDidReturnChoice:(NSString *)text {
    NSLog(@"%@", text);
}

@end

