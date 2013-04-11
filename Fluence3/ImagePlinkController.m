//
//  ImagePlinkController.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ImagePlinkController.h"

@implementation ImagePlinkController

@synthesize toolBar = _toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tag						= [[NSMutableDictionary alloc] init];
		_tagItems					= [[NSMutableArray alloc] init];
        appdt                       = [[UIApplication sharedApplication] delegate];
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
    // Do any additional setup after loading the view from its nib.

}
- (void)loadView
{
    // create public objects first so they're available for custom configuration right away. positioning comes later.
    _container							= [[UIView alloc] initWithFrame:CGRectZero];
    _innerContainer						= [[UIView alloc] initWithFrame:CGRectZero];
    _toolbar							= [[UIToolbar alloc] initWithFrame:CGRectZero];
    _tagContainer                       = [[RemoveEventView alloc] initWithFrame:CGRectZero];
    _plinkImage                         = [[UIImageView alloc] initWithFrame:CGRectZero];
    
// setup tag
    _tagContainer.hidden					    = NO;
    _tagContainer.backgroundColor               = [UIColor colorWithWhite:1.0 alpha:0.0];
    _tagContainer.frame                         = CGRectMake(100, 114, 256, 278);

// setup Image view
    _plinkImage.image = appdt.img;
    
//setup buttons
    _saveButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the button
    _saveButton.frame = CGRectMake(5, 20, 40, 40);
    //background image
//    UIImage *buttonImage = [UIImage imageNamed:@"heart-icon.png"];
    
    //create the button and assign the image addSubview:button
    
//    [_saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //set the button's title
    [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
    //listen for clicks
    [_saveButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    //add the button to the view

    _cancelButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the button
    _cancelButton.frame = CGRectMake(5, 20, 40, 40);
    //background image
    //    UIImage *buttonImage = [UIImage imageNamed:@"heart-icon.png"];
    
    //create the button and assign the image addSubview:button
    
    //    [_saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //set the button's title
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    //listen for clicks
    [_cancelButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    //add the button to the view
    
    // set view
	self.view = _container;
    
    // add items to their containers
	[_container addSubview:_innerContainer];
	[_innerContainer addSubview:_toolbar];
    [_innerContainer addSubview:_plinkImage];    
    [_innerContainer addSubview:_tagContainer];    

    [_toolbar addSubview:_cancelButton];
    [_toolbar addSubview:_saveButton];
    
}
- (void)viewDidUnload {
    
    [_cancelButton release], _cancelButton = nil;
    [_saveButton release], _saveButton = nil;
    [_tagItems release], _tagItems = nil;
    [_container release], _container = nil;
    [_innerContainer release], _innerContainer = nil;
    [_toolbar release], _toolbar = nil;
    [_tagContainer release], _tagContainer = nil;
    [_tag release], _tag = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [_tag release];
    _tag = nil;
	
    [_tagItems release];
    _tagItems = nil;
    
    [_tagContainer release];
    _tagContainer = nil;
    
    [_saveButton release];
    _saveButton = nil;
    
    [_cancelButton release];
    _cancelButton = nil;
    
    [_toolbar release];
    _toolbar = nil;
    
    [_plinkImage release];
    _plinkImage = nil;
    
    [_innerContainer release];
    _innerContainer = nil;
    
    [_container release];
    _container = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
