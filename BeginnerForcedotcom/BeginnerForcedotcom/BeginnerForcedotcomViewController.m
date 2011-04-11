//
//  BeginnerForcedotcomViewController.m
//  BeginnerForcedotcom
//
//  Created by Quinton Wall on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BeginnerForcedotcomViewController.h"
#import "BeginnerForcedotcomAppDelegate.h"

//added for handling Force.com login
#import "ZKLoginResult.h"

@implementation BeginnerForcedotcomViewController

//stores the query results data
@synthesize dataRows;
@synthesize tableView;


- (void)dealloc
{
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    tableView.delegate = self;
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [tableView release];
    tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Server Switchboard Results

/**
 * this gets called if we are using standard login, ie not oauth
 */
- (void)loginResult:(ZKLoginResult *)result error:(NSError *)error
{
    //NSLog(@"loginResult: %@ error: %@", result, error);
    if (result && !error)
    {
        NSLog(@"Hey, we logged in (with the new switchboard)!");
        
      //  [self getRows];
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
    
    // hide login dialog
    BeginnerForcedotcomAppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app hideLogin];
}

/**
 * This is the method which gets executed upon successful login for oauth
 */
- (void)loginOAuth:(ZKOAuthViewController *)oAuthViewController error:(NSError *)error
{
    NSLog(@"loginOAuth: %@ error: %@", oAuthViewController, error);
    
    if ([oAuthViewController accessToken] && !error)
    {
        [[ZKServerSwitchboard switchboard] setApiUrlFromOAuthInstanceUrl:[oAuthViewController instanceUrl]];
        [[ZKServerSwitchboard switchboard] setSessionId:[oAuthViewController accessToken]];
        [[ZKServerSwitchboard switchboard] setOAuthRefreshToken:[oAuthViewController refreshToken]];
        BeginnerForcedotcomAppDelegate *app = [[UIApplication sharedApplication] delegate];
        [self getAccounts];
        [app hideLogin];

    }
}

-(void)receivedErrorFromAPICall:(NSError *)err 
{
	//SimpleForcedotcomAppDelegate *app = [[UIApplication sharedApplication] delegate];
	//[app popupActionSheet:err];
}

#pragma mark - Working with Force.com data

- (void)getAccounts
{
    NSString *queryString = 
        @"Select Id, Name, BillingState, Phone From Account order by Name limit 100";
    [[ZKServerSwitchboard switchboard] query:queryString target:self
                                    selector:@selector(queryResult:error:context:) context:nil];
    
}

/**
 * Called by the switchboard after a query is executed. It is set up as a selector in the getAccounts method
 */
- (void)queryResult:(ZKQueryResult *)result error:(NSError *)error context:(id)context
{
    //NSLog(@"queryResult:%@ eror:%@ context:%@", result, error, context);
    if (result && !error)
    {
        self.dataRows = [NSMutableArray arrayWithArray:[result records]];
        
        [self.view addSubview:tableView];
        [tableView reloadData];
        
    
    }
    else if (error)
    {
        [self receivedErrorFromAPICall: error];
    }
}


#pragma mark - Table Events
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [self.dataRows count];
}


#pragma mark Assign Force.com data to table cells
/**
 * required method for a UITable delegate. This is where we take the data from our query and assign it to 
 * our table cells to be displayed.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
	ZKSObject *obj = [dataRows objectAtIndex:indexPath.row];
	cell.textLabel.text = [obj fieldValue:@"Name"];
    
    return cell;
}


@end
