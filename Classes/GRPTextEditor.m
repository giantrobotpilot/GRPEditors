//
//  RatingTextEditController.m
//  BrewTour CO
//
//  Created by Andrew Christensen on 2/18/10.
//  Copyright 2010 Giant Robot Pilot. All rights reserved.
//

#import "GRPTextEditor.h"


@implementation GRPTextEditor

@synthesize allowBlank;
@synthesize delegate;
@synthesize value;
@synthesize textField;

#pragma mark -

- (void)dealloc {
    [value release];
    [textField release];
    
    [super dealloc];
}

-(id)initWithText:(NSString *)text {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.value = text;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(save)];
    
    CGRect rect = CGRectMake(20, 10, 280, 31);
    self.textField = [[UITextField alloc] initWithFrame:rect];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textField.delegate = self;
    if (self.value) {
        self.textField.text = self.value;
    }
    
    // TableView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.tableView.tableHeaderView = headerView;
    [headerView release];
    headerView.backgroundColor = [UIColor clearColor];
    
    [self.textField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

-(void)save {
    NSString *textValue = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!self.allowBlank && [textValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:BLANK_FIELD_TITLE
                                                        message:BLANK_FIELD_MESSAGE
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    } 
    else {
        [delegate GRPTextEditorDidReturnText:textValue];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell.contentView addSubview:self.textField];
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self save];
    return YES;
}

@end

