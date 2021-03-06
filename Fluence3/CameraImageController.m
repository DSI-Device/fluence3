//
//  CameraImageController.m
//  Fluence3
//
//  Created by Naim on 3/28/13.
//
//

#import "CameraImageController.h"
#import "TakeCameraPhoto.h"
#import "ImagePlinkController.h"
#import "AROverlayViewController.h"
@interface CameraImageController ()

@end

@implementation CameraImageController
@synthesize counterTimer,captureManager,scanningLabel,counterLabel,arOverlayView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(handleBack:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    //[backButton release];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)view01Action
{
    TakeCameraPhoto* nextView = [[TakeCameraPhoto alloc]initWithNibName:@"TakeCameraPhoto" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (IBAction)openPlinkingController
{
    ImagePlinkController* nextView = [[ImagePlinkController alloc]initWithNibName:@"ImagePlinkController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (IBAction)cameraTimerAction
{
    
    arOverlayView = [[[AROverlayViewController alloc] initWithNibName:nil bundle:nil]autorelease];
    arOverlayView.title = @"Capture Photo";
    [self.navigationController pushViewController:arOverlayView animated:true];

}
- (void)handleBack:(id)sender {
    ISViewController *nCameraImage = [[[ISViewController alloc] initWithNibName:@"ISViewController" bundle:nil]autorelease];
    nCameraImage.title = @"Fluence";
    [self.navigationController pushViewController:nCameraImage animated:true];
}


@end


