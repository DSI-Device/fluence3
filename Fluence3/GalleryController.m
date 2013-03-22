//
//  GalleryController.m
//  FBTest
//
//  Created by Joseph Armand Baroi on 3/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GalleryController.h"

@implementation GalleryController

@synthesize localGallery;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)loadView {
	[super loadView];
    self.title = @"FGallery";
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
	localCaptions = [[NSArray alloc] initWithObjects:@"Lava", @"Hawaii", @"Audi", @"Happy New Year!",@"Frosty Web",nil];
    localImages = [[NSArray alloc] initWithObjects: @"lava.jpeg", @"hawaii.jpeg", @"audi.jpg",nil];
    
    networkCaptions = [[NSArray alloc] initWithObjects:@"Happy New Year!",@"Frosty Web",nil];
    networkImages = [[NSArray alloc] initWithObjects:@"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"http://farm6.static.flickr.com/5007/5311573633_3cae940638.jpg",nil];
    
    appdt = [[UIApplication sharedApplication] delegate];
    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    
    [self presentViewController:localGallery animated:YES completion:nil];
    //[appdt.navController pushViewController:networkGallery animated:YES];
    //[appdt.mainViewController pushViewController:localGallery animated:YES];
    [localGallery release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreenDown:)];
    swipeGestureDown.numberOfTouchesRequired = 1;
    swipeGestureDown.direction = (UISwipeGestureRecognizerDirectionDown);
    [[self view] addGestureRecognizer:swipeGestureDown];
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreenUp:)];
    swipeGestureUp.numberOfTouchesRequired = 1;
    swipeGestureUp.direction = (UISwipeGestureRecognizerDirectionUp);
    [[self view] addGestureRecognizer:swipeGestureUp];

    // Do any additional setup after loading the view from its nib.
}
- (void) swipedScreenDown:(UISwipeGestureRecognizer*)swipeGesture {
    //[utils showAlert:@"Warning !!" message:@"Activation Failed !! Please try again with correct credential." delegate:self];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Next Date"
                          message: @"Next date selected!"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
- (void) swipedScreenUp:(UISwipeGestureRecognizer*)swipeGesture {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Previous Date"
                          message: @"Previous date selected!"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - FGalleryViewControllerDelegate Methods

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    if( gallery == localGallery ) {
        num = [localImages count];
    }
    else if( gallery == networkGallery ) {
        num = [networkImages count];
    }
	return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	if( gallery == localGallery ) {
		return FGalleryPhotoSourceTypeLocal;
	}
	else return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    if( gallery == localGallery ) {
        caption = [localCaptions objectAtIndex:index];
    }
    else if( gallery == networkGallery ) {
        caption = [networkCaptions objectAtIndex:index];
    }
	return caption;
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [localImages objectAtIndex:index];
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [networkImages objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}

- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}


@end
