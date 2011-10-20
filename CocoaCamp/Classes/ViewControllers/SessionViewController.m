//
//  SessionViewController.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 10/19/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import "SessionViewController.h"
#import "Session.h"
#import "WebServiceDataManager.h"
#import "CCBranding.h"

@implementation SessionViewController
@synthesize coreDataManager;

- (void)dealloc{
    [wsMgr release], wsMgr = nil;
    [super dealloc];
}

-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	if (self = [super initWithNibName:@"OLDSessionViewController" bundle:bundle]){
		self.title = @"Schedule";
		UIImage* image = [UIImage imageNamed:@"calendar.png"];
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:image tag:0] autorelease];
        wsMgr = [[WebServiceDataManager alloc] init];
        [wsMgr setDelegate:self];
    }
	return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)applyBrandingIfPresent{
    
    CCBranding *branding = [[CCBranding alloc] init];
    [branding applyConfiguredBrandingToTableView:[self tableView]];
    [branding release];
}


#pragma mark - Schedule Update

- (void)scheduleUpdateComplete{
    
}

- (void)updateSchedule{
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    [wsMgr refreshSessionSchedule];
    [apool release];
}

- (void)checkUpdateSchedule{
    lastSessionsUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSessionsUpdate"];
    NSTimeInterval intervalSinceLastUpdate = [lastSessionsUpdate timeIntervalSinceNow];
    if (!lastSessionsUpdate || ABS(intervalSinceLastUpdate) > (5 * 60) ) {
        // [self updateSchedule];
        [self performSelectorInBackground:@selector(updateSchedule) withObject:nil];
        lastSessionsUpdate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:lastSessionsUpdate forKey:@"lastSessionsUpdate"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
}


#pragma mark - View lifecycle


         
         

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self tableView] setRowHeight:64.0];
    [self setCoreDataManager:[CoreDataManager sharedUIThreadInstance]];
    
    
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    self.title = @"Schedule";
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setFetchedResultsController:nil];
    [coreDataManager release];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self checkUpdateSchedule];
    [self applyBrandingIfPresent];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionCount = [[[self fetchedResultsController] sections] count];
    return sectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo name]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Session *session = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = session.sessionTimeString;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.text = session.title;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    UIColor *cellBgColor = ([[session flagged] boolValue]) ? [UIColor whiteColor]:[UIColor colorWithRed:0.88 green:0.93 blue:0.98 alpha:1.0];
    cell.contentView.backgroundColor = cellBgColor;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle 
                 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Session *session = (Session*)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    NSNumber *flagged = [NSNumber numberWithBool:![[session flagged] boolValue]];
    [session setFlagged:flagged];
    [[self coreDataManager] save];
}

#pragma mark - Fetched Results Controller
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [[self tableView] reloadData];
}


-(NSFetchedResultsController *)fetchedResultsController{
    if(fetchedResultsController){
        return fetchedResultsController;
    }
    NSFetchRequest *allSessions = [[self coreDataManager] fetchRequestForEntityNamed:@"Session"];
    [allSessions setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"datetimeStart" ascending:YES]]];
    
    [allSessions setFetchBatchSize:20];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:allSessions
                                                                   managedObjectContext:[[self coreDataManager] managedObjectContext]
                                                                     sectionNameKeyPath:@"sessionDayTitle" 
                                                                              cacheName:@"AllSessions"
                                ];
    [fetchedResultsController setDelegate:self];
    
    return fetchedResultsController;
    
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController{
    id oldFrc = fetchedResultsController;
    fetchedResultsController = [aFetchedResultsController retain];
    [oldFrc setDelegate:nil];
    [oldFrc release];
}

@end
