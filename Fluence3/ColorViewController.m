//
//  ColorViewController.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 3/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ColorViewController.h"

@implementation ColorViewController

@synthesize imageView;

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
	[imageView release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdt = [[UIApplication sharedApplication] delegate];
    imageView.image = [self makeImageBlackWhite:appdt.imgOptimized];

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

#pragma mark - Filter Features

-(IBAction)reset:(id)sender
{
    appdt = [[UIApplication sharedApplication] delegate];
	imageView.image=appdt.imgOptimized;
}

-(IBAction)done:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}


- (UIImage *)makeImageBlackWhite:(UIImage *)img
{
    CIImage *beginImage = [CIImage imageWithCGImage:img.CGImage];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
    
    CGImageRelease(cgiimage);
    
    return newImage;
}

- (UIImage *)makeSepia:(UIImage *)img
{
    CIImage *cimage = [CIImage imageWithCGImage:img.CGImage];
    
    CIFilter *myFilter = [CIFilter filterWithName:@"CISepiaTone"];
    
    [myFilter setDefaults];
    [myFilter setValue:cimage forKey:@"inputImage"];
    [myFilter setValue:[NSNumber numberWithFloat:0.8f] forKey:@"inputIntensity"];
    
    CIImage *image = [myFilter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:image fromRect:image.extent];
    UIImage *resultUIImage = [UIImage imageWithCGImage:cgImage];
    
    return resultUIImage;
}

#pragma mark - Tab Bar Features

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"tag clicked %i", item.tag);
    if(item.tag==0)
    {
        //your code
        appdt.imgOptimized = [self makeImageBlackWhite:imageView.image];
        imageView.image = appdt.imgOptimized;
    }
    else if(item.tag == 1)
    {
        appdt.imgOptimized = [self makeSepia:imageView.image];
        imageView.image = appdt.imgOptimized;
    }
    else
    {
        //your code
    }
}



@end
