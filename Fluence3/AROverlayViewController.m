#import "AROverlayViewController.h"
#import "TakePhotoForCrop.h"
#import <ImageIO/ImageIO.h>


@implementation AROverlayViewController

@synthesize captureManager;
@synthesize scanningLabel;
@synthesize counterLabel;
@synthesize counterTimer,appdt,counter,autoButton;

- (void)viewDidLoad {
    counter = 5;
    appdt = [[UIApplication sharedApplication]delegate];
	[self setCaptureManager:[[[CaptureSessionManager alloc] init] autorelease]];
    
	[[self captureManager] addVideoInputFrontCamera:NO]; // set to YES for Front Camera, No for Back camera
    
    [[self captureManager] addStillImageOutput];
    
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
    [[[self captureManager] previewLayer] setBounds:layerRect];
    [[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
    [overlayImageView setFrame:CGRectMake(30, 100, 260, 200)];
    [[self view] addSubview:overlayImageView];
    [overlayImageView release];

    
    /*
    UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[overlayButton setImage:[UIImage imageNamed:@"scanbutton.png"] forState:UIControlStateNormal];
    [overlayButton setTitle:@"Capture" forState:UIControlStateNormal];
    [overlayButton setBackgroundColor:[UIColor clearColor]];
    [overlayButton setFrame:CGRectMake(30, 320, 100, 30)];
    [overlayButton addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:overlayButton];
    */
    
    autoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [autoButton setTitle:@"Start" forState:UIControlStateNormal];
    [autoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    autoButton.titleLabel.font = [UIFont fontWithName:@"Courier" size:26.0];
    autoButton.frame = CGRectMake(110, 350, 100, 30);
    autoButton.backgroundColor = [UIColor clearColor];
    autoButton.layer.borderColor = [UIColor blackColor].CGColor;
    autoButton.layer.borderWidth = 0.5f;
    autoButton.layer.cornerRadius = 10.0f;
    [autoButton addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:autoButton];
    
    /*
    UIButton *captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [captureButton setTitle:@"Capture" forState:UIControlStateNormal];
    [captureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    captureButton.titleLabel.font = [UIFont fontWithName:@"Courier" size:26.0];
    captureButton.frame = CGRectMake(170, 400, 130, 30);
    captureButton.backgroundColor = [UIColor clearColor];
    captureButton.layer.borderColor = [UIColor blackColor].CGColor;
    captureButton.layer.borderWidth = 0.5f;
    captureButton.layer.cornerRadius = 10.0f;
    [captureButton addTarget:self action:@selector(captureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:captureButton];
     */
  
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
    [self setScanningLabel:tempLabel];
    [tempLabel release];
	[scanningLabel setBackgroundColor:[UIColor clearColor]];
	[scanningLabel setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
	[scanningLabel setTextColor:[UIColor redColor]]; 
	[scanningLabel setText:@"1"];
    [scanningLabel setHidden:YES];
	[[self view] addSubview:scanningLabel];	
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
    
	[[captureManager captureSession] startRunning];
    
    
    
    
    
    
}

-(void) captureButtonPressed {
    //[[self scanningLabel] setHidden:NO];
    [[self captureManager] captureStillImage];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
}

- (void) scanButtonPressed {
    /*[[self captureManager] captureStillImage];
    counterTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(showCounter:)
                                                userInfo:nil
                                                 repeats:YES];*/
    /*counterTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showCounter) userInfo:nil repeats:YES] retain];*/
    [[self autoButton] setHidden:YES];
    
    counter = 5;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1
                                             target:self
                                           selector:@selector(showCounter:)
                                           userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.counterTimer = timer;


}



- (void) showCounter:(NSTimer *) timer {
	UILabel *tempLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(105, 90, 300, 200)];
    [self setCounterLabel:tempLabel2];
    [tempLabel2 release];
	[counterLabel setBackgroundColor:[UIColor clearColor]];
	[counterLabel setFont:[UIFont fontWithName:@"Courier" size: 200.0]];
	[counterLabel setTextColor:[UIColor redColor]];
    
    NSString* clabel = [NSString stringWithFormat:@"%d", counter];
    
	[counterLabel setText: clabel];
    [counterLabel setHidden:NO];
	[[self view] addSubview:counterLabel];
    
     
    [self performSelector:@selector(hideLabel:) withObject:[self counterLabel] afterDelay:1];
    
    counter--;
    
    if(counter == 0)
    {
        [[self captureManager] captureStillImage];
        
        [timer invalidate];
        timer = nil;
        //[[NSNotificationCenter defaultCenter] postNotification:[[timer userInfo] objectForKey:@"notificationEnd"]];

    }
   
}


- (void)hideLabel:(UILabel *)label {
	[label setHidden:YES];
}

- (void)saveImageToPhotoAlbum
{
    [[self autoButton] setHidden:NO];
    appdt.img = appdt.imgOptimized =[[self captureManager] stillImage];
    TakePhotoForCrop *nextView = [[TakePhotoForCrop alloc]initWithNibName:@"TakePhotoForCrop" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    
    //UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else {
        [[self scanningLabel] setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  [captureManager release], captureManager = nil;
  [scanningLabel release], scanningLabel = nil;
    
  [super dealloc];
}

@end

