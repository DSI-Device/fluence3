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
@interface CameraImageController ()

@end

@implementation CameraImageController

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

@end


