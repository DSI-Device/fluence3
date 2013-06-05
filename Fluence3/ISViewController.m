#import "ISViewController.h"
#import "GalleryController.h"
#import "MainViewController.h"
#import "CameraImageController.h"
#import "SelectListViewController.h"
#import "MapViewController.h"
#import "SelectPoseListViewController.h"
#import "SelectTasteListViewController.h"
#import "Fluence3AppDelegate.h"
#import "JSNotifier.h"
#import "BrandListViewController.h"
#import "CountryListViewController.h"
#import "FollowListViewController.h"
@implementation ISViewController

@synthesize gc;
@synthesize mc;
@synthesize notiImage,notiNumber,appdt;
@synthesize nCameraImage,selectListView,mapViewController,selectPoseListView,selectTasteListView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    
    
    appdt = [[UIApplication sharedApplication] delegate];
    int x = [appdt.notification intValue];
    if( x > 0)
    {
        notiImage.hidden = NO;
        notiNumber.hidden = NO;
        notiNumber.text = appdt.notification;
        
    }
    else
    {
        notiImage.hidden = YES;
        notiNumber.hidden = YES;
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd));
    appdt = [[UIApplication sharedApplication] delegate];
    int x = [appdt.notification intValue];
    if( x > 0)
    {
        notiImage.hidden = NO;
        notiNumber.hidden = NO;
        notiNumber.text = appdt.notification;
        JSNotifier *notify = [[JSNotifier alloc]initWithTitle:[[@"You have " stringByAppendingString:appdt.notification]stringByAppendingString:@" new notifications"]];
        notify.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyCheck1.png"]];
        [notify showFor:3.0];
    }
    else
    {
        notiImage.hidden = YES;
        notiNumber.hidden = YES;
        
    }
    
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
    [self setNotiNumber:nil];
    [self setNotiImage:nil];
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
    [notiNumber release];
    [notiImage release];
    [appdt release];
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
    /*
    selectPoseListView = [[[SelectPoseListViewController alloc] initWithNibName:@"SelectPoseListViewController" bundle:nil]autorelease];
    selectPoseListView.title = @"Find People";
    [self.navigationController pushViewController:selectPoseListView animated:true];
    */
    /*
    selectListView = [[[SelectListViewController alloc] initWithNibName:@"SelectListViewController" bundle:nil]autorelease];
    selectListView.title = @"Find People";
    [self.navigationController pushViewController:selectListView animated:true];
    */
    /*
    selectTasteListView = [[[SelectTasteListViewController alloc] initWithNibName:@"SelectTasteListViewController" bundle:nil]autorelease];
    selectTasteListView.title = @"Find Event";
    [self.navigationController pushViewController:selectTasteListView animated:true];
     */
    /*
     BrandListViewController *brandListViewController = [[[BrandListViewController alloc] initWithNibName:@"BrandListViewController" bundle:nil]autorelease];
    brandListViewController.title = @"Select Brand";
    [self.navigationController pushViewController:brandListViewController animated:true];
     */
    /*
    CountryListViewController *countryListViewController = [[[CountryListViewController alloc] initWithNibName:@"CountryListViewController" bundle:nil]autorelease];
    countryListViewController.title = @"Select Country";
    [self.navigationController pushViewController:countryListViewController animated:true];
     */
    
    FollowListViewController *followListViewController = [[[FollowListViewController alloc] initWithNibName:@"FollowListViewController" bundle:nil]autorelease];
    followListViewController.title = @"Select Follow";
    [self.navigationController pushViewController:followListViewController animated:true];
}
- (IBAction)mapViewClicked{
    mapViewController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil]autorelease];
    selectListView.title = @"Map View";
    [self.navigationController pushViewController:mapViewController animated:true];
}
@end
