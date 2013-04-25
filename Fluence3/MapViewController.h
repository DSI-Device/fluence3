//
//  MapViewController.h
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/22/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    NSMutableArray* annotationsArray;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray* annotationsArray;

- (void)getLocations;
- (void)setLocations;
- (void)gotoLocation;
- (void)refreshMap;

@end
