//
//  StyleEditViewController.m
//  BrewTour CO
//
//  Created by Andrew Christensen on 2/18/10.
//  Copyright 2010 Giant Robot Pilot. All rights reserved.
//

#import "GRPCoreDataListChooser.h"


@implementation GRPCoreDataListChooser

@synthesize choicesArray;
@synthesize chosenValue;
@synthesize delegate;
@synthesize textField;
@synthesize textSelected;
@synthesize entityName;
@synthesize managedObjectContext;
@synthesize propertyName;

#pragma mark -

- (void)dealloc {
    
    [choicesArray release];
    [chosenValue release];
    [textField release];
    [entityName release];
    [propertyName release];

    [super dealloc];
}
-(id)initWithProperty:(NSString *)property inEntity:(NSString *)entity inManagedObjectContext:(NSManagedObjectContext *)iContext  chosenValue:(NSString *)chosen{
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.propertyName = property;
        self.entityName = entity;
        self.managedObjectContext = iContext;
        self.chosenValue = chosen;
    }
    return self;
}


#pragma mark View Methods

-(void)viewWillAppear:(BOOL)animated
{
    [self populateChoicesArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NavigationBar
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // TableView
    //self.tableView.backgroundColor = kCellBackgroundColor;
    self.tableView.separatorColor = [UIColor orangeColor];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    if (textSelected) {
        self.chosenValue = self.textField.text;
        [self addNewListObject];
    }

    //[delegate assignValue:self.chosenValue toKey:@"group"];
    [delegate GRPCoreDataListChooserDelegateDidReturnChoice:self.chosenValue];
}


#pragma mark Controller Methods

-(void)addNewListObject
{
    if ( ![self.textField.text isEqualToString:@""] ) {
        NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                                   inManagedObjectContext:self.managedObjectContext];
        [newObject setValue:self.textField.text forKey:self.propertyName];
    }
}

-(void)populateChoicesArray
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:[NSEntityDescription entityForName:self.entityName
                                        inManagedObjectContext:self.managedObjectContext]];
    NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:self.propertyName ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameSorter];
    [nameSorter release];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    self.choicesArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [choicesArray count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *AddCellIdentifier = @"AddCell";
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCellIdentifier] autorelease];
            self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 290, 28)];
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            self.textField.placeholder = @"New Group";
            [cell addSubview:self.textField];
            self.textField.delegate = self;
        }
        if (textSelected) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        NSString *styleStr = [[choicesArray objectAtIndex:indexPath.row] valueForKey:self.propertyName];
        if ([styleStr isEqualToString:self.chosenValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = [UIColor colorWithRed:.32 green:.4 blue:.57 alpha:1];
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor darkTextColor];
        }
        
        cell.textLabel.text = styleStr;
        //cell.textLabel.font = [UIFont fontWithName:kFontName2 size:15];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"tableView:didSelectRowAtIndexPath:(section %d, row %d)", indexPath.section, indexPath.row);
    if (indexPath.section == 0) {
        NSLog(@"selected section 0");
        [self.textField becomeFirstResponder];
    }
    else {
        NSLog(@"selected other");
        self.textSelected = NO;
        self.chosenValue = [[choicesArray objectAtIndex:indexPath.row] valueForKey:self.propertyName];
        [self.tableView reloadData];
    }

    
}


#pragma mark Table View Editing methods

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove object from database
    [self.managedObjectContext deleteObject:[choicesArray objectAtIndex:indexPath.row]];
    
    [self populateChoicesArray];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark TextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"-textFieldDidBeginEditing:");
    self.textSelected = YES;
    //[self.tableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"-textField:shouldChangeCharactersInRange:");
    self.chosenValue = self.textField.text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"-textFieldShouldReturn:");
    if ([self.textField.text isEqualToString:@""]) {
        self.textSelected = NO;
    }
    [self.textField resignFirstResponder];
    [self.tableView reloadData];
    return YES;
}

@end

