//
//  insuranceListViewController.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TagCategoryController.h"


@implementation TagCategoryController
@synthesize action_status,followed_s,dataSource, searchBar, listTableView, spinner, countText, filterView, isSearchFromOnline, selectedDataSource, spinnerBg, defaultElemId, maxSelectionLimit, totalCount, currentLimit,appdt,category,brand,categoryid, delegate;

- (void)loadView{
    [super loadView];
    dao = [[searchDao alloc] init];
    self.searchBar.placeholder = [self getSearchBarTitle];
    self.currentLimit = 5000;
    adapter = [MYSBJsonStreamParserAdapter new];
    adapter.delegate = self;
    parser = [MYSBJsonStreamParser new];
    parser.delegate = adapter;
    parser.multi = YES;
    [utils roundUpView:[[self.spinnerBg subviews] objectAtIndex:0]];
    appdt = [[UIApplication sharedApplication]delegate];
    [self.listTableView setHidden:YES];
    NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getPlinkListData/" ];
    [self performSelector:@selector(triggerAsyncronousRequest2:) withObject: serverUrl];
}

- (void) triggerAsyncronousRequest1: (NSString *)url {
	
	[self.spinner startAnimating];
	self.spinner.hidden = NO;
	self.spinnerBg.hidden = NO;
	
	url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];//asynchronous call
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}

- (void) triggerAsyncronousRequest2: (NSString *)url {
	
	[self.spinner startAnimating];
	self.spinner.hidden = NO;
	self.spinnerBg.hidden = NO;
	
    
    
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
        
		[self.listTableView reloadData];
		[self.spinner stopAnimating];
		self.spinner.hidden = YES;
		self.spinnerBg.hidden = YES;
		[self.listTableView setHidden:NO];
	}
	if(self.action_status==2)
	{
		NSLog(@"Follow/Unfollow");
	}
    
    /*if (theConnection) {
     
     receiveData = [NSMutableData data];
     
     }}*/
}

- (IBAction) searchContentChanged: (id) sender{
	
	NSLog(@"inside searchContentChanged......");
	self.currentLimit = 5000;
	//NSString *serverUrl = [[NSString stringWithString: [utils performSelector:@selector(getServerURL)]] stringByAppendingFormat:@"doctor/jsonLite&prac_ids=1&doc_name=%@&limit=%d", self.searchBar.text, self.currentLimit];
    NSString *serverUrl=[utils performSelector:@selector(getServerURL)];
	//NSString *serverUrl=@"http://103.4.147.139/fluence3";
	[self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
}

// methods for NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Connection didReceiveResponse: %@ - %@", response, [response MIMEType]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"Connection didReceiveAuthenticationChallenge: %@", challenge);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
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
        
		[self.listTableView reloadData];
		[self.spinner stopAnimating];
		self.spinner.hidden = YES;
		self.spinnerBg.hidden = YES;
		[self.listTableView setHidden:NO];
	}
	if(self.action_status==2)
	{
		NSLog(@"Follow/Unfollow");
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ ",[error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
    [connection release];
	
}


//methods for json parser protocol

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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"Count cellForRowAtIndexPath %u", [self.dataSource count]);
	NSUInteger row = [indexPath row];
	NSDictionary *rowData = [self.dataSource objectAtIndex:row];
	//[rowData setValue:@"dsd" forKey:@"mykey"];
	
		
		static NSString *cellTableIdentifier = @"CustomCategoryListCellIdentifier";
		
		CustomCategoryListCell *cell = (CustomCategoryListCell *)[tableView dequeueReusableCellWithIdentifier:cellTableIdentifier];
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCategoryListCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
			cell.selectedBackgroundView = [[[UIView alloc] init] autorelease];
			[cell.selectedBackgroundView setBackgroundColor:[UIColor orangeColor]];
		}
		cell.CategoryName.text = [rowData objectForKey:@"Name"];
        cell.CategoryID = [rowData objectForKey:@"ID"];
    
		
		return cell;
        
	
}
//[objectWithOurMethod methodName:int1 ];
- (void)tappedFollowBtn2:(id) sender
{
    NSLog(@"Button Clicked...");
        
}



// event handler after selecting a table row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Row selected...");
    NSLog(@"Count tappedFollowBtn2 %u", [self.dataSource count]);
    //UIButton *senderButton = (UIButton *)sender;
  
    NSUInteger row = [indexPath row];
	NSDictionary *rowData = [self.dataSource objectAtIndex:row];
	//NSString *qwe = [rowData JSONRepresentation];
    //
    CustomCategoryListCell *cell = (CustomCategoryListCell *) [listTableView cellForRowAtIndexPath:indexPath];
    
    category = [rowData objectForKey:@"Name"];
    categoryid=[rowData objectForKey:@"ID"];
	appdt.TagID = [rowData objectForKey:@"ID"];
    
   	TagBrandController* nextView1 = [[TagBrandController alloc]initWithNibName:@"TagBrandController" bundle:[NSBundle mainBundle]];
    nextView1.delegate = self;
    [self presentViewController:nextView1 animated:YES completion:nil];
    [nextView1 release];
	[self hideKeyboard:nil];
}

- (IBAction) hideKeyboard: (id) sender{
	[searchBar resignFirstResponder];
}

- (IBAction) clearAllBtnClicked: (id) sender{
	NSDictionary *defaultElem = nil;
	
	if(self.defaultElemId != nil){
		for( NSDictionary *dict in self.selectedDataSource ){
			if([self.defaultElemId isEqual:[dict objectForKey:@"id"]]){
				defaultElem = [dict copyWithZone:nil];
				break;
			}
		}
	}
	
	[self.selectedDataSource removeAllObjects];
	if( defaultElem != nil )
		[self.selectedDataSource addObject:defaultElem];
	
	[self.listTableView reloadData];
}

- (IBAction) selectionDone: (id) sender{
	[self.filterView setSelectedOption:selectedDataSource delegate:self];
}

- (NSString *) getSearchBarTitle{
	return @"Search";
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[defaultElemId release];
	[parser release];
	[adapter release];
	parser = nil;
	adapter = nil;
	[spinnerBg release];
	[dao release];
	[selectedDataSource release];
	[filterView release];
	[countText release];
	[spinner release];
	[listTableView release];
	[dataSource release];
	[searchBar release];
	[followed_s release];
    
    [super dealloc];
}
- (void)addBrandViewController:(TagBrandController *)controller didFinishEnteringBrand:(NSString *)item
{
    brand = item;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate addItemViewController:self didFinishEnteringItem:category:brand];
}
@end
