//
//  MapViewController.h
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/22/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Fluence3AppDelegate.h"
@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    NSMutableArray* annotationsArray;
    Fluence3AppDelegate *appdt;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray* annotationsArray;
@property (strong, nonatomic) Fluence3AppDelegate *appdt;
- (void)getLocations;
- (void)setLocations;
- (void)gotoLocation;
- (void)refreshMap;

@end
