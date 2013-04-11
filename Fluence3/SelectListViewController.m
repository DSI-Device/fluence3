//
//  insuranceListViewController.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectListViewController.h"


@implementation SelectListViewController

@synthesize action_status,followed_s,dataSource, searchBar, listTableView, spinner, countText, filterView, isSearchFromOnline, selectedDataSource, spinnerBg, defaultElemId, maxSelectionLimit, totalCount, currentLimit;

- (void)loadView{
	[super loadView];
	dao = [[searchDao alloc] init];
	self.searchBar.placeholder = [self getSearchBarTitle];
	self.currentLimit = 50;
	adapter = [MYSBJsonStreamParserAdapter new];
	adapter.delegate = self;
	parser = [MYSBJsonStreamParser new];
	parser.delegate = adapter;
	parser.multi = YES;
    [utils roundUpView:[[self.spinnerBg subviews] objectAtIndex:0]];
    
	[self.listTableView setHidden:YES];
	//NSString *serverUrl = [[NSString stringWithString: [utils performSelector:@selector(getServerURL)]] stringByAppendingFormat:@"doctor/jsonLite&prac_ids=1&limit=%d",self.currentLimit];
    //NSString *serverUrl=[utils performSelector:@selector(getServerURL)];
	NSString *serverUrl=@"http://103.4.147.139/fluence3";
	[self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
	//[utils roundUpView:[[self.spinnerBg subviews] objectAtIndex:0]];
	
}

- (void) triggerAsyncronousRequest: (NSString *)url {
	
	[self.spinner startAnimating];
	self.spinner.hidden = NO;
	self.spinnerBg.hidden = NO;
	
	url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];//asynchronous call
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}

- (IBAction) searchContentChanged: (id) sender{
	
	NSLog(@"inside searchContentChanged......");
	self.currentLimit = 50;
	//NSString *serverUrl = [[NSString stringWithString: [utils performSelector:@selector(getServerURL)]] stringByAppendingFormat:@"doctor/jsonLite&prac_ids=1&doc_name=%@&limit=%d", self.searchBar.text, self.currentLimit];
    //NSString *serverUrl=[utils performSelector:@selector(getServerURL)];
	NSString *serverUrl=@"http://103.4.147.139/fluence3";
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
		self.totalCount = [[countData objectForKey:@"count"] intValue];
		NSLog(@"total count %d",self.totalCount);
		
		[self.dataSource removeObjectAtIndex:0];
		if ([self.dataSource count] < self.totalCount) {
			[self.dataSource addObject:[[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Showing %d out of %d",self.currentLimit,self.totalCount],@"count",nil] autorelease] ];
		}
		[self.dataSource addObject:[[[NSDictionary alloc] init] autorelease] ];//empty allocation in-order to able to select the last element
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
	if ([rowData objectForKey:@"count"] != NULL && ![[rowData objectForKey:@"count"] isEqual:@""] ) {
		
		static NSString *cellTableIdentifier = @"viewMoreCell";
		
		viewMoreCell *cell = (viewMoreCell *)[tableView dequeueReusableCellWithIdentifier:cellTableIdentifier];
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"viewMoreCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
			cell.backgroundView =  [[[UIView alloc] init] autorelease];
			cell.backgroundView.backgroundColor = [UIColor blackColor];
			[cell.backgroundView setAlpha:0.60f];
			cell.selectedBackgroundView = [[[UIView alloc] init] autorelease];
			[cell.selectedBackgroundView setBackgroundColor:[UIColor orangeColor]];
		}
		cell.showMessage.text = [rowData objectForKey:@"count"];
		if ((self.totalCount - self.currentLimit) > 50 || (self.totalCount - self.currentLimit) < 0) {
			cell.moreCountMessage.text = @"Show 50 More";
		}else {
			cell.moreCountMessage.text = [NSString stringWithFormat:@"Show %d More",(self.totalCount - self.currentLimit)];
		}
		[cell setUserInteractionEnabled:YES];
		return cell;
		
	}else {
		
		static NSString *cellTableIdentifier = @"CustomPeopleListCellIdentifier";
		
		CustomPeopleListCell *cell = (CustomPeopleListCell *)[tableView dequeueReusableCellWithIdentifier:cellTableIdentifier];
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomPeopleListCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
			cell.selectedBackgroundView = [[[UIView alloc] init] autorelease];
			[cell.selectedBackgroundView setBackgroundColor:[UIColor orangeColor]];
		}
		cell.userName.text = [rowData objectForKey:@"userName"];
        cell.userID = [rowData objectForKey:@"userID"];
		cell.followed.hidden = NO;
        cell.followed.tag=[indexPath row];
        followed_s = [rowData objectForKey:@"followed"];
        [cell.followed addTarget:self action:@selector(tappedFollowBtn2:)  forControlEvents:UIControlEventTouchUpInside];
		NSString *serverUrl = [@"http://103.4.147.139/fluence3/images/" stringByAppendingFormat:@"%@",[rowData objectForKey:@"userImage"]];
		
		NSURL *url = [NSURL URLWithString:serverUrl];
		
		NSData *data = [[NSData alloc] initWithContentsOfURL:url];
		
		UIImage *tmpImage = [[UIImage alloc] initWithData:data];
		
		//yourImageView.image = tmpImage;
		
		
		[cell.userImage setImage:tmpImage];
		if ([followed_s isEqualToString:@"1"]) {
			cell.isFollowed = YES;
            [cell.followed setTitle:@"Unfollow" forState:UIControlStateNormal];
		}else if([followed_s isEqualToString:@"0"]){
			cell.isFollowed = NO;
            [cell.followed setTitle:@"Follow" forState:UIControlStateNormal];
			
		}else {
			cell.followed.hidden = YES;
		}
		
		return cell;

	}
}
//[objectWithOurMethod methodName:int1 ];
- (void)tappedFollowBtn2:(id) sender
{
    NSLog(@"Button Clicked...");
    NSLog(@"Count tappedFollowBtn2 %u", [self.dataSource count]);
    //UIButton *senderButton = (UIButton *)sender;
    NSIndexPath *indexPath = [listTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    NSUInteger row = [indexPath row];
	NSDictionary *rowData = [self.dataSource objectAtIndex:row];
	//
    CustomPeopleListCell *cell = (CustomPeopleListCell *) [listTableView cellForRowAtIndexPath:indexPath];
	if (!cell.isFollowed) {
        
        [rowData setValue:@"1" forKey:@"followed"];
        cell.isFollowed = YES;
        [cell.followed setTitle:@"Unfollow" forState:UIControlStateNormal];
		followed_s = @"1";
        
		
    }else {
        [rowData setValue:@"0" forKey:@"followed"];
        cell.isFollowed = NO;
        [cell.followed setTitle:@"Follow" forState:UIControlStateNormal];
		followed_s = @"0";
        
    }
	
    
	
   	NSLog(@"Follower ID : %@ ",cell.userID);
	NSString *myRequestString = [[NSString alloc] initWithFormat:@"userID=%@&followed=%@",cell.userID,followed_s];
	NSLog(@"%@ ",myRequestString);
	NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
	NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: @"http://103.4.147.139/fluence3/index.php/welcome/follow/" ] ];
   	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [ request setHTTPMethod: @"POST" ];
	[ request setHTTPBody: myRequestData ];
	NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    if (conn) NSLog(@"Connection Successful");
	
    
}
     
     // event handler after selecting a table row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSLog(@"Row selected...");
     
     /* NSUInteger row = [indexPath row];
	 NSDictionary *rowData = [self.dataSource objectAtIndex:row];
	 if ([rowData objectForKey:@"count"] != NULL && ![[rowData objectForKey:@"count"] isEqual:@""] ) {
	 viewMoreCell *cell = (viewMoreCell *)[tableView cellForRowAtIndexPath:indexPath];
	 [cell setUserInteractionEnabled:NO];
	 self.currentLimit += 50;
	 if (self.isSearchFromOnline) {
	 NSString *serverUrl = [utils performSelector:@selector(getServerURL)];
	 serverUrl = [serverUrl stringByAppendingFormat:@"&limit=%d",self.currentLimit];
	 [self performSelector:@selector(triggerAsyncronousRequest:) withObject: serverUrl];
	 }else {
	 
	 [NSThread detachNewThreadSelector:@selector(loadLocalRows) toTarget:self withObject:nil];
	 }
	 
	 
	 
	 }else if ([rowData objectForKey:@"userName"] != NULL && ![[rowData objectForKey:@"userName"] isEqual:@""] ) {
	 
	 NSLog(@"option selected on select list");
	 if( self.defaultElemId != nil && [self.defaultElemId isEqual:[rowData objectForKey:@"userID"]]){
	 [utils showAlert:@"Warning !!" message:@"Default option can't be removed." delegate:nil];
	 return;
	 }
	 CustomPeopleListCell *cell = (CustomPeopleListCell *)[tableView cellForRowAtIndexPath:indexPath];
	 [cell.followed addTarget:self action:@selector(tappedFollowBtn2:) forControlEvents:UIControlEventTouchUpInside];
	 if (!cell.isFollowed) {
	 if (self.maxSelectionLimit > 0 && [selectedDataSource count] >= self.maxSelectionLimit) {
	 [utils showAlert:@"Warning !!" message:@"Maximum selection limit exceeded." delegate:nil];
	 return;
	 }
	 [selectedDataSource addObject:rowData];
	 //cell.isFollowed = YES;
	 //[cell.followed setTitle:@"Unfollow" forState:UIControlStateNormal];
	 //[cell.userImage setImage:[UIImage imageNamed:@"checkbox_ticked.png"]];
	 
	 }else {
	 [utils deleteRowFromList:selectedDataSource row:rowData];
	 //cell.isFollowed = NO;
	 //[cell.followed setTitle:@"Follow" forState:UIControlStateNormal];
	 //[cell.userImage setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"]];
	 }
	 }*/
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


@end
