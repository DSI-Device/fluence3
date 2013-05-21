//
//  UAModalExampleView.m
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "UAExampleModalPanel.h"
#import "GalleryCommentViewController.h"
#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation UAExampleModalPanel

@synthesize viewLoadedFromXib,commentTextField,fg;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
	if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
		commentTextField.delegate = self;
        
		
		////////////////////////////////////
		// RANDOMLY CUSTOMIZE IT
		////////////////////////////////////
		// Show the defaults mostly, but once in awhile show a completely random funky one
		        
        
		//////////////////////////////////////
		// SETUP RANDOM CONTENT
		//////////////////////////////////////
//		UIWebView *wv = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
//		[wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://urbanapps.com/product_list"]]];
//		
//		UITableView *tv = [[[UITableView alloc] initWithFrame:CGRectZero] autorelease];
//		[tv setDataSource:self];
//		
//		UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
//		[iv setImage:[UIImage imageNamed:@"UrbanApps.png"]];
//		[iv setContentMode:UIViewContentModeScaleAspectFit];
        
        GalleryCommentViewController *my = [[GalleryCommentViewController alloc] initWithNibName:@"GalleryCommentViewController" bundle:nil] ;
        //SelectListViewController *my = [[UIApplication sharedApplication] delegate];
        //UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        my.view.frame = CGRectMake(0, 0, 0, 0);
		
		[[NSBundle mainBundle] loadNibNamed:@"UAExampleView" owner:self options:nil];
		
		NSArray *contentArray = [NSArray arrayWithObjects:viewLoadedFromXib, nil];
		
		int i = arc4random() % [contentArray count];
		v = [[contentArray objectAtIndex:i] retain];
		[self.contentView addSubview:my.view];
		
	}	
	return self;
}




-(IBAction)userDoneEnteringText:(id)sender
{
    commentTextField = (UITextField*)sender;
    // do whatever you want with this text field
}

- (void)dealloc {
    [v release];
	[viewLoadedFromXib release];
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[v setFrame:self.contentView.bounds];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *cellIdentifier = @"UAModalPanelCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}
	
	[cell.textLabel setText:[NSString stringWithFormat:@"Row %d", indexPath.row]];
	
	return cell;
}

#pragma mark - Actions
- (IBAction)buttonPressed:(id)sender {
	// The button was pressed. Lets do something with it.
	
	// Maybe the delegate wants something to do with it...
	if ([delegate respondsToSelector:@selector(superAwesomeButtonPressed:)]) {
		[delegate performSelector:@selector(superAwesomeButtonPressed:) withObject:sender];
        
        // Or perhaps someone is listening for notifications 
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SuperAwesomeButtonPressed" object:sender];
	}
    
	NSLog(@"Super Awesome Button pressed!");
}




- (IBAction)shareButton:(id)sender {
    
    
}

@end
