//
//  TakeCameraPhoto.m
//  FBTest
//
//  Created by Naim on 3/22/13.
//
//

#import "TakeCameraPhoto.h"
#import "ShowCropedImage.h"
#import "ColorViewController.h"

#define SHOW_PREVIEW NO

#import <QuartzCore/QuartzCore.h>

#ifndef CGWidth
#define CGWidth(rect)                   rect.size.width
#endif

#ifndef CGHeight
#define CGHeight(rect)                  rect.size.height
#endif

#ifndef CGOriginX
#define CGOriginX(rect)                 rect.origin.x
#endif

#ifndef CGOriginY
#define CGOriginY(rect)                 rect.origin.y
#endif
@interface TakeCameraPhoto ()

@end

@implementation TakeCameraPhoto

@synthesize image,button,cropButton,appdt;
@synthesize imageCropper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [image release];
    [button release];
    [cropButton release];
    [imageCropper release];
    [super dealloc];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
    //image.image = img;
    self.imageCropper = [[[BJImageCropper alloc] initWithImage:img andMaxSize:CGSizeMake(450, 340)]autorelease];
    [self.view addSubview:self.imageCropper];
    self.imageCropper.center = self.view.center;
    self.imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imageCropper.imageView.layer.shadowRadius = 3.0f;
    self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
    self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
    
    [self dismissModalViewControllerAnimated:YES];
    cropButton.hidden = NO;
    
    //[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}
- (IBAction)selectPhotos
{
    self.image.hidden=YES;
    
    @try
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;  
            //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            picker.delegate = self; 
            
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"The device does not have camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        
    }
    @catch (NSException *exception) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    /*
    
   
    appdt.img = appdt.imgOptimized = [UIImage imageNamed:@"gavandme.jpg"];
    
//    self.imageCropper.frame = CGRectMake(0, 0 ,300, 400);
    
    self.imageCropper = [[[BJImageCropper alloc] initWithImage:appdt.img andMaxSize:CGSizeMake(450, 340)]autorelease];
//    self.imageCropper.frame = CGRectMake(0, 0 ,300, 400);
    [self.view addSubview:self.imageCropper];
    self.imageCropper.center = self.view.center;
    self.imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imageCropper.imageView.layer.shadowRadius = 3.0f;
    self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
    self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
    
    //[self dismissModalViewControllerAnimated:YES];
    cropButton.hidden = NO;
      */
        
}
- (IBAction)cropping
{
    [self.imageCropper saveCroppedImage];
    self.image.image = [self.imageCropper getCroppedImage];
    ShowCropedImage* nextView = [[ShowCropedImage alloc]initWithNibName:@"ShowCropedImage" bundle:[NSBundle mainBundle]];
    //    nextView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    [self presentViewController:nextView animated:YES completion:nil];
    
    cropButton.hidden = NO;
    
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    appdt = [[UIApplication sharedApplication] delegate];
    
    /*self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tactile_noise.png"]];
     
     self.imageCropper = [[BJImageCropper alloc] initWithImage:[UIImage imageNamed:@"gavandme.jpg"] andMaxSize:CGSizeMake(1024, 600)];
     [self.view addSubview:self.imageCropper];
     self.imageCropper.center = self.view.center;
     self.imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
     self.imageCropper.imageView.layer.shadowRadius = 3.0f;
     self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
     self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
     
     [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
     cropButton.hidden = NO;
     if (SHOW_PREVIEW) {
     self.image = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,self.imageCropper.crop.size.width * 0.1, self.imageCropper.crop.size.height * 0.1)];
     self.image.image = [self.imageCropper getCroppedImage];
     self.image.clipsToBounds = YES;
     self.image.layer.borderColor = [[UIColor whiteColor] CGColor];
     self.image.layer.borderWidth = 2.0;
     //[self.view addSubview:self.preview];
     }*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString: @"test.png"] ];
    appdt.img = appdt.imgOptimized = self.image.image = [UIImage imageWithContentsOfFile:path];
    
    @try
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;  
            //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            picker.delegate = self; 
            
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"The device does not have camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        
    }
    @catch (NSException *exception) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    self.image.hidden=YES;
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidUnload
{
    [self setImageCropper:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
        [self updateDisplay];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateDisplay];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    
    self.image.hidden=YES;
    appdt.img = appdt.imgOptimized = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    
    self.imageCropper = [[[BJImageCropper alloc] initWithImage:appdt.img  andMaxSize:CGSizeMake(450, 340)]autorelease];
    [self.view addSubview:self.imageCropper];
    self.imageCropper.center = self.view.center;
    self.imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imageCropper.imageView.layer.shadowRadius = 3.0f;
    self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
    self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
    
    //[self dismissModalViewControllerAnimated:YES];
    cropButton.hidden = NO;

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
- (void)updateDisplay {
    //self.boundsText.text = [NSString stringWithFormat:@"(%f, %f) (%f, %f)", CGOriginX(self.imageCropper.crop), CGOriginY(self.imageCropper.crop), CGWidth(self.imageCropper.crop), CGHeight(self.imageCropper.crop)];
    
    if (SHOW_PREVIEW) {
    }
}

@end
