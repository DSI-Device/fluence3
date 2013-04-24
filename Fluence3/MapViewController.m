//
//  MapViewController.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/22/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "MyAnnotation.h"

@implementation MapViewController

@synthesize mapView,annotations;

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
    [self getLocations];
    
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

#pragma mark - Map Related

- (void)gotoLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.786996;
    newRegion.center.longitude = -122.440100;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
	
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)getLocations
{
    
    NSDictionary *user1 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"3", @"userId", @"Naim", @"userName", @"37.786996", @"userLatitude", @"-122.419281", @"userLontitude",@"1", @"userCat", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic",nil];
    NSDictionary *user2 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"7", @"userId", @"Nazmul", @"userName", @"37.810000", @"userLatitude", @"-122.477989", @"userLontitude",@"1", @"userCat", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic", nil];
    NSDictionary *user3 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"4", @"userId", @"Shuvo", @"userName", @"37.760000", @"userLatitude", @"-122.447989", @"userLontitude",@"1", @"userCat", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic", nil];
    NSDictionary *user4 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"2", @"userId", @"Anik", @"userName", @"37.80000", @"userLatitude", @"-122.407989", @"userLontitude",@"1", @"userCat", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic", nil];
    
    annotations = [[NSMutableArray alloc] initWithObjects:user1,user2, user3, user4,nil];
    
    CLLocation *userLoc = mapView.userLocation.location;
    CLLocationCoordinate2D userCoordinate = userLoc.coordinate;
	
	NSLog(@"user latitude = %f",userCoordinate.latitude);
	NSLog(@"user longitude = %f",userCoordinate.longitude);
	
	mapView.delegate=self;
		
	CLLocationCoordinate2D theCoordinate1;
    theCoordinate1.latitude = 37.786996;
    theCoordinate1.longitude = -122.419281;
	
	CLLocationCoordinate2D theCoordinate2;
    theCoordinate2.latitude = 37.810000;
    theCoordinate2.longitude = -122.477989;
	
	CLLocationCoordinate2D theCoordinate3;
    theCoordinate3.latitude = 37.760000;
    theCoordinate3.longitude = -122.447989;
	
	CLLocationCoordinate2D theCoordinate4;
    theCoordinate4.latitude = 37.80000;
    theCoordinate4.longitude = -122.407989;
	
    [self setLocations];
	
}

- (void)setLocations
{
    int annCount = [annotations count];
    
    for (int i = 0; i < annCount; i++) {
        id row = [annotations objectAtIndex:i];
        MyAnnotation* myAnnotation1=[[MyAnnotation alloc] init];
        NSString * str = [NSString stringWithFormat:[row objectForKey:@"userId"]];
        myAnnotation1.uniqueId = str;
        
        CLLocationCoordinate2D theCoordinate1;
        str = [NSString stringWithFormat:[row objectForKey:@"userLatitude"]];
        theCoordinate1.latitude = [str doubleValue];
        str = [NSString stringWithFormat:[row objectForKey:@"userLontitude"]];
        theCoordinate1.longitude = [str doubleValue];
        
        myAnnotation1.coordinate=theCoordinate1;
        str = [NSString stringWithFormat:[row objectForKey:@"userName"]];
        myAnnotation1.title=str;
        myAnnotation1.subtitle=@"Send Message";
        
        str = [NSString stringWithFormat:[row objectForKey:@"userPic"]];
        myAnnotation1.imageUrl = str;
        
        static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
        MKPinAnnotationView* pinView = [[[MKPinAnnotationView alloc]
                                         initWithAnnotation:myAnnotation1 reuseIdentifier:AnnotationIdentifier] autorelease];
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:myAnnotation1.title forState:UIControlStateNormal];
        [rightButton addTarget:self
                        action:@selector(showDetails:)
              forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        
        [mapView addAnnotation:myAnnotation1];
        [myAnnotation1 release];
    }   
    	
	NSLog(@"%d",[annotations count]);
	//[self gotoLocation];//to catch perticular area on screen
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
	for (id annotation in annotations) {
		NSLog(@"fly to on");
        NSString * str;
        CLLocationCoordinate2D theCoordinate1;
        str = [NSString stringWithFormat:[annotation objectForKey:@"userLatitude"]];
        theCoordinate1.latitude = [str doubleValue];
        str = [NSString stringWithFormat:[annotation objectForKey:@"userLontitude"]];
        theCoordinate1.longitude = [str doubleValue];;
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(theCoordinate1);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
			//NSLog(@"else-%@",annotationPoint.x);
        }
    }
    
    // Position the map so that all overlays and annotations are visible on screen.
    mapView.visibleMapRect = flyTo;

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	NSLog(@"welcome into the map view annotation");
	MyAnnotation *vma = (MyAnnotation *)annotation;
	// if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
	// try to dequeue an existing pin view first
	static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
	MKPinAnnotationView* pinView = [[[MKPinAnnotationView alloc]
									 initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
	pinView.animatesDrop=YES;
	pinView.canShowCallout=YES;
	pinView.pinColor=MKPinAnnotationColorPurple;
	
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[rightButton setTitle:annotation.title forState:UIControlStateNormal];
//	[rightButton addTarget:self	action:@selector(calloutAccessoryControlTapped:) forControlEvents:UIControlEventTouchUpInside];
	pinView.rightCalloutAccessoryView = rightButton;
	
	UIImageView *profileIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.png"]];
	pinView.leftCalloutAccessoryView = profileIconView;
	[profileIconView release];
   
	return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view 
calloutAccessoryControlTapped:(UIControl *)control
{
    id<MKAnnotation> selectedAnn = view.annotation;
    
    if ([selectedAnn isKindOfClass:[MyAnnotation class]])
    {
        MyAnnotation *vma = (MyAnnotation *)selectedAnn;
        NSLog(@"selected VMA = %@, blobkey=%@", vma, vma.uniqueId);
    }
    else
    {
        NSLog(@"selected annotation (not a VMA) = %@", selectedAnn);
    }
    
    //do something with the selected annotation... 
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//    
//    // Add an annotation
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    
//    CLLocationCoordinate2D location;
//    location.latitude = userLocation.coordinate.latitude+.005;//51.509979999999999
//    location.longitude = userLocation.coordinate.longitude;
//    
//    point.coordinate = location;
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
//    
//    [self.mapView addAnnotation:point];
}

@end
