//
//  MapViewController.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/22/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

@synthesize mapView;

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

- (void)dealloc
{
    [mapView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
       self.mapView.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSDictionary *user1 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"1", @"userId", @"Naim", @"userName", @"51.5099", @"userLatitude", @"51.5099", @"userLontitude",@"1", @"userCat", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic",nil];
    NSDictionary *user2 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"2", @"userId", @"Nazmul", @"userName", @"51.5099", @"userLatitude", @"51.5099", @"userLontitude",@"1", @"userCat", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic", nil];
    
    CLLocationCoordinate2D location;
    location.latitude = 37.33182;
    location.longitude = -122.03118;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 500, 500);
    [self.mapView setRegion:region animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]autorelease];
    annotation.coordinate = location;
    annotation.title = @"test Title";
    annotation.subtitle = @"testing";
    [self.mapView addAnnotation:annotation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude+.005;//51.509979999999999
    location.longitude = userLocation.coordinate.longitude;
    
    point.coordinate = location;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
}

@end
