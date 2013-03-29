//
//  CameraImageController.m
//  Fluence3
//
//  Created by Naim on 3/28/13.
//
//

#import "CameraImageController.h"
#import "TakeCameraPhoto.h"
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
//    nextView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self presentViewController:nextView animated:YES completion:nil];
//    [nextView release];

    
    // THIS IS THE MAGIC PART 2
//    UIViewController *topVC = (UIViewController *)self.navigationController.delegate;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    
}
@end


