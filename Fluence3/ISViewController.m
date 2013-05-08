#import "ISViewController.h"
#import "GalleryController.h"
#import "MainViewController.h"
#import "CameraImageController.h"
#import "SelectListViewController.h"
#import "MapViewController.h"
#import "SelectPoseListViewController.h"
@implementation ISViewController

@synthesize gc;
@synthesize mc;
@synthesize nCameraImage,selectListView,mapViewController,selectPoseListView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super didReceiveMemoryWarning];
}

- (void)viewWillUnload
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super viewWillUnload];
}

- (void)viewDidUnload
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [super viewDidUnload];
}

- (void)dealloc
{
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    [gc release];
    [mc release];
    [nCameraImage release];
    [selectListView release];
    [mapViewController release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)pushViewController
{
    UIViewController *viewController = [[[UIViewController alloc] init] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)galleryClicked {
    gc = [[[GalleryController alloc] initWithNibName:@"GalleryController" bundle:nil]autorelease];
    gc.title = @"Gallery";
    [self.navigationController pushViewController:gc animated:true];
}

- (IBAction)profileClicked {
    mc = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil]autorelease];
    mc.title = @"Profile";
    [self.navigationController pushViewController:mc animated:true];
}

- (IBAction)newCameraImageClicked {
    nCameraImage = [[[CameraImageController alloc] initWithNibName:@"CameraImageController" bundle:nil]autorelease];
    nCameraImage.title = @"Capture New";
    [self.navigationController pushViewController:nCameraImage animated:true];
}
- (IBAction)findPeopleClicked{
    
    selectPoseListView = [[[SelectPoseListViewController alloc] initWithNibName:@"SelectPoseListViewController" bundle:nil]autorelease];
    selectPoseListView.title = @"Find People";
    [self.navigationController pushViewController:selectPoseListView animated:true];
    
    /*
    selectListView = [[[SelectListViewController alloc] initWithNibName:@"SelectListViewController" bundle:nil]autorelease];
    selectListView.title = @"Find People";
    [self.navigationController pushViewController:selectListView animated:true];
    */
}
- (IBAction)mapViewClicked{
    mapViewController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil]autorelease];
    selectListView.title = @"Map View";
    [self.navigationController pushViewController:mapViewController animated:true];
}
@end
