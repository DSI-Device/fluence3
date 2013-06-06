//
//  GalleryController.m
//  FBTest
//
//  Created by Joseph Armand Baroi on 3/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GalleryController.h"
#import "GalleryNavController.h"

@implementation GalleryController


#pragma mark - Memory management

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

- (void)dealloc {
    [subNavCntlr release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)loadView {
	[super loadView];
    self.title = @"Gallery";
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    

    
    subNavCntlr = [[UINavigationController alloc] init];
    subNavCntlr.view.frame = subNavContainer.bounds;
    
    GalleryNavController *drillDown1 = [[GalleryNavController alloc] initWithNibName:@"GalleryNavController" bundle:nil];
    drillDown1.title = @"Gallery Type Menu";
    [subNavCntlr pushViewController:drillDown1 animated:YES];
    [drillDown1 release];
    
    subNavCntlr.delegate = self; // THIS IS THE MAGIC, PART 1
    
    [subNavContainer addSubview:subNavCntlr.view];
    
    
//    [self tableView:((UITableView*) self.tableView) didSelectRowAtIndexPath:0];    
//    appdt = [[UIApplication sharedApplication] delegate];
//    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
//    
//    [self presentViewController:localGallery animated:YES completion:nil];
//    //[appdt.navController pushViewController:networkGallery animated:YES];
//    //[appdt.mainViewController pushViewController:localGallery animated:YES];
//    [localGallery release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(handleBack:)];
    
    self.navigationItem.leftBarButtonItem = backButton;

    // Do any additional setup after loading the view from its nib.
}

- (void)handleBack:(id)sender {
    ISViewController *nCameraImage = [[[ISViewController alloc] initWithNibName:@"ISViewController" bundle:nil]autorelease];
    nCameraImage.title = @"Fluence";
    [self.navigationController pushViewController:nCameraImage animated:true];
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



@end
