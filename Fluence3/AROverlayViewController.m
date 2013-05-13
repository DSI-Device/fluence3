#import "AROverlayViewController.h"

@implementation AROverlayViewController

@synthesize captureManager;
@synthesize scanningLabel;
@synthesize counterLabel;
@synthesize counterTimer;

- (void)viewDidLoad {
  
	[self setCaptureManager:[[[CaptureSessionManager alloc] init] autorelease]];
  
	[[self captureManager] addVideoInput];
  
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                CGRectGetMidY(layerRect))];
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
    
    UIButton *autoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [autoButton setTitle:@"Auto" forState:UIControlStateNormal];
    [autoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    autoButton.titleLabel.font = [UIFont fontWithName:@"Courier" size:26.0];
    autoButton.frame = CGRectMake(20, 400, 100, 30);
    autoButton.backgroundColor = [UIColor clearColor];
    autoButton.layer.borderColor = [UIColor blackColor].CGColor;
    autoButton.layer.borderWidth = 0.5f;
    autoButton.layer.cornerRadius = 10.0f;
    [autoButton addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:autoButton];
    
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

  
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
    [self setScanningLabel:tempLabel];
    [tempLabel release];
	[scanningLabel setBackgroundColor:[UIColor clearColor]];
	[scanningLabel setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
	[scanningLabel setTextColor:[UIColor redColor]]; 
	[scanningLabel setText:@"1"];
    [scanningLabel setHidden:YES];
	[[self view] addSubview:scanningLabel];	
    
    
	[[captureManager captureSession] startRunning];
    
    
}

-(void) captureButtonPressed {
    [[self captureManager] addStillImageOutput];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
}

- (void) scanButtonPressed {
    /*[[self captureManager] captureStillImage];
    counterTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(showCounter:)
                                                userInfo:nil
                                                 repeats:YES];*/
    /*counterTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showCounter) userInfo:nil repeats:YES] retain];*/

    NSTimer *timer = [NSTimer timerWithTimeInterval:1
                                             target:self
                                           selector:@selector(showCounter:)
                                           userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.counterTimer = timer;


}

int counter = 5;

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
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(screenshotImage, nil, nil, nil);
        /*
        [[self captureManager] addStillImageOutput];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];

        [timer invalidate];
        timer = nil;
        [[NSNotificationCenter defaultCenter] postNotification:[[timer userInfo] objectForKey:@"notificationEnd"]];
        */
    }
   
}


- (void)hideLabel:(UILabel *)label {
	[label setHidden:YES];
}

- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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

