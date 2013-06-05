//
//  TagBrandController.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TagBrandController.h"

@implementation TagBrandController

@synthesize delegate,dataSource,action_status,appdt,currentLimit,totalCount;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentLimit = 5000;
    adapter = [MYSBJsonStreamParserAdapter new];
    adapter.delegate = self;
    parser = [MYSBJsonStreamParser new];
    parser.delegate = adapter;
    parser.multi = YES;
    appdt = [[UIApplication sharedApplication]delegate];
    NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getBrandListData/" ];
    [self performSelector:@selector(triggerAsyncronousRequest2:) withObject: serverUrl];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void) triggerAsyncronousRequest2: (NSString *)url {
	    
	url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    
    NSDictionary *jsoning = [[NSDictionary alloc] initWithObjectsAndKeys: appdt.userGalleryId, @"UserId", nil];
    
    
   
    //NSString *jsonRequest = [jsoning JSONRepresentation];
    
    
    NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    [dictionnary setObject:jsoning forKey:@"postData"];
    
    NSString *jsonRequest = [dictionnary JSONRepresentation];
    
    //NSError *error = nil;
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionnary                                                       options:kNilOptions                                                         error:&error];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    NSURL *nsurl = [NSURL URLWithString:url ];
    
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl
                                    
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                    
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSURLResponse* response;
    NSError* error = nil;
    
    //Capturing server response
    NSData* data = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSLog(@"Connection didReceiveData of length: %u", data.length);
	NSLog(@"String sent from server %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	MYSBJsonStreamParserStatus status = [parser parse:data];
	
	if (status == MYSBJsonStreamParserError) {
		NSLog(@"Parser error: %@", parser.error);
		
	} else if (status == MYSBJsonStreamParserWaitingForData) {
		NSLog(@"Parser waiting for more data");
	}
	NSLog(@"row size : %u",[self.dataSource count]);
	NSDictionary *countData = [self.dataSource objectAtIndex:0];
	self.action_status = [[countData objectForKey:@"action"] intValue];
	if(self.action_status==1)
	{
		[self.dataSource removeObjectAtIndex:0];
        countData = [self.dataSource objectAtIndex:0];
		self.totalCount = [[countData objectForKey:@"count"] intValue];
		NSLog(@"total count %d",self.totalCount);
		
		[self.dataSource removeObjectAtIndex:0];
		if ([self.dataSource count] < self.totalCount) {
			[self.dataSource addObject:[[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Showing %d out of %d",self.currentLimit,self.totalCount],@"count",nil] autorelease] ];
		}
		//[self.dataSource addObject:[[[NSDictionary alloc] init] autorelease] ];//empty allocation in-order to able to select the last element
        

	}
	if(self.action_status==2)
	{
		NSLog(@"Follow/Unfollow");
	}
    
    /*if (theConnection) {
     
     receiveData = [NSMutableData data];
     
     }}*/
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (void)parser:(MYSBJsonStreamParser *)parser foundArray:(NSArray *)array {
	NSLog(@"inside foundArray %u", [array count]);
	if([array count] > 0){
		
		for (NSDictionary *dict in array) {
            self.action_status = [[dict objectForKey:@"action"] intValue];
            if(self.action_status==2)
            {
                return;
            }
            if(self.action_status==1)
            {
                NSLog(@"New Json");
                self.dataSource = [[NSMutableArray alloc] initWithObjects:nil];
            }
			[self.dataSource addObject:dict];
		}
	}
}

- (void)parser:(MYSBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
	NSLog(@"inside foundObject");
	self.dataSource = [[NSMutableArray alloc] initWithObjects:nil];
	[self.dataSource addObject:dict];
}

// methods for tableview protocols

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Count numberOfRowsInSection %u", [self.dataSource count]);
	return [self.dataSource count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSUInteger row = [indexPath row];
	NSDictionary *rowData = [self.dataSource objectAtIndex:row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [rowData objectForKey:@"Name"];
    appdt.TagBrandID = [rowData objectForKey:@"ID"];
    cell.imageView.image = [UIImage imageNamed:@"action-location.png"];
    // Configure the cell...
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
    NSString *itemToPassBack = @"Pass this value back to ViewControllerA";
    NSUInteger row = [indexPath row];
	NSDictionary *rowData = [self.dataSource objectAtIndex:row];
	//NSString *qwe = [rowData JSONRepresentation];
    //
    UITableViewCell *cell = (UITableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    itemToPassBack = cell.textLabel.text;

    [self.delegate addBrandViewController:self didFinishEnteringBrand:itemToPassBack];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
