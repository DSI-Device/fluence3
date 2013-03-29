#import "ISViewController.h"
#import "GalleryController.h"
#import "MainViewController.h"
#import "CameraImageController.h"

@implementation ISViewController

@synthesize gc;
@synthesize mc;
@synthesize nCameraImage;

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
    
    // Set the friend picker delegate
    //gc.delegate = self;
    
    [self.navigationController pushViewController:gc animated:true];
}

- (IBAction)profileClicked {
    mc = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil]autorelease];
    mc.title = @"Profile";
    
    // Set the friend picker delegate
    //gc.delegate = self;
    
    [self.navigationController pushViewController:mc animated:true];
}

- (IBAction)newCameraImageClicked {
    nCameraImage = [[[CameraImageController alloc] initWithNibName:@"CameraImageController" bundle:nil]autorelease];
    nCameraImage.title = @"Capture New";
    
    // Set the friend picker delegate
    //gc.delegate = self;
    
    [self.navigationController pushViewController:nCameraImage animated:true];
}


@end
