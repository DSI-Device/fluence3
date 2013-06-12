//
//  insuranceListViewController.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageViewController.h"
#import "Fluence3AppDelegate.h"
#import "commentPanel.h"
#import "stylistModal.h"
#import "UANoisyGradientBackground.h"
#import "UAGradientBackground.h"

@implementation MessageViewController

@synthesize action_status,followed_s,dataSource, searchBar, listTableView, spinner, countText, filterView, isSearchFromOnline, selectedDataSource, spinnerBg, defaultElemId, maxSelectionLimit, totalCount, currentLimit,commentTextField,fgc,appdt;

- (void)loadView{
	[super loadView];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(handleBack1:)];
    
    self.navigationItem.leftBarButtonItem = backButton;

    appdt = [[UIApplication sharedApplication] delegate];
    [self.navigationController setNavigationBarHidden:NO];
	dao = [[searchDao alloc] init];
	self.searchBar.placeholder = [self getSearchBarTitle];
	self.currentLimit = 5000;
	adapter = [MYSBJsonStreamParserAdapter new];
	adapter.delegate = self;
	parser = [MYSBJsonStreamParser new];
	parser.delegate = adapter;
	parser.multi = YES;
    [utils roundUpView:[[self.spinnerBg subviews] objectAtIndex:0]];
    
	[self.listTableView setHidden:YES];
	//NSString *serverUrl = [[NSString stringWithString: [utils performSelector:@selector(getServerURL)]] stringByAppendingFormat:@"doctor/jsonLite&prac_ids=1&limit=%d",self.currentLimit];
    NSString *serverUrl=[ [utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getMessage/" ];
    [self performSelector:@selector(triggerAsyncronousRequest1:) withObject: serverUrl];
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

- (void) triggerAsyncronousRequest1: (NSString *)url {
	
	[self.spinner startAnimating];
	self.spinner.hidden = NO;
	self.spinnerBg.hidden = NO;
	
    
    NSDictionary *jsoning = [[NSDictionary alloc] initWithObjectsAndKeys: appdt.userGalleryId , @"UserId", nil];
    
    NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    [dictionnary setObject:jsoning forKey:@"postData"];
    
    NSString *jsonStr = [dictionnary JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonStr);
    
    NSURL *nsurl = [ NSURL URLWithString: url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
    return 75.0f;
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
		
		static NSString *cellTableIdentifier = @"CustomMessageCellIdentifier";
		//CustomGalleryCommentCell
		CustomMessageCell *cell = (CustomMessageCell *)[tableView dequeueReusableCellWithIdentifier:cellTableIdentifier];
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomMessageCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
			cell.selectedBackgroundView = [[[UIView alloc] init] autorelease];
			[cell.selectedBackgroundView setBackgroundColor:[UIColor orangeColor]];
		}
		cell.senderName.text = [rowData objectForKey:@"senderName"];
        cell.senderID = [rowData objectForKey:@"messageID"];
		cell.messageDate.text = [rowData objectForKey:@"messageDate"];
        cell.messageBody.text = [rowData objectForKey:@"messageBody"];
        int not = [[rowData objectForKey:@"IsRead"] intValue];
        if(not==0)
        {
            cell.notiImage.hidden = FALSE;
        }
        
//        if([[rowData objectForKey:@"read"] intValue] == 0)
//        {
//            NSLog([rowData objectForKey:@"read"]);
//            cell.contentView.backgroundColor  = [UIColor colorWithRed:0.8 green:0.9 blue:1 alpha:1];
//        }
//        else
//        {
//            cell.contentView.backgroundColor  = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
//            
//        }
        
        //NSString *serverUrl=[utils performSelector:@selector(getServerURL)];
		NSString *serverUrl = [rowData objectForKey:@"messageImage"];
		
		NSURL *url = [NSURL URLWithString:serverUrl];
		
		NSData *data = [[NSData alloc] initWithContentsOfURL:url];
		
		UIImage *tmpImage = [[UIImage alloc] initWithData:data];
		
		//yourImageView.image = tmpImage;
		
		
		[cell.messageImage setImage:tmpImage];
		
		
		return cell;
        
	}
}
//[objectWithOurMethod methodName:int1 ];
- (void)tappedFollowBtn2:(id) sender
{
    NSLog(@"Button Clicked...");

    
}

// event handler after selecting a table row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Row selected...");
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [self.dataSource objectAtIndex:row];
    appdt.currentStylistImageId = [rowData objectForKey:@"senderID"];
    NSLog(@"ID is %@", appdt.currentStylistImageId);
    CurrentMessageViewController *nCameraImage = [[[CurrentMessageViewController alloc] initWithNibName:@"CurrentMessageViewController" bundle:nil]autorelease];
    nCameraImage.title = @"Message";
    [self.navigationController pushViewController:nCameraImage animated:true];
    
	 
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

- (IBAction)commentTextButton:(id)sender {
    NSString *string = commentTextField.text;
    commentTextField.text = @"";
    fgc = [[FGalleryViewController alloc] initWithNibName:nil bundle:nil];
    [fgc commentDone:string];
    
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
    [commentTextField release];
    commentTextField = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewDidLoad {
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
    
    [commentTextField release];
    [super dealloc];
}


-(IBAction)userDoneEnteringText:(id)sender
{
    commentTextField = (UITextField*)sender;
    // do whatever you want with this text field
}
- (void)handleBack1:(id)sender {
    MainViewController *nCameraImage = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil]autorelease];
    nCameraImage.title = @"Fluence";
    [self.navigationController pushViewController:nCameraImage animated:true];
}

@end
