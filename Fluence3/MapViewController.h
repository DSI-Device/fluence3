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
    NSMutableArray* annotations;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray* annotations;

- (void)getLocations;
- (void)setLocations;

@end
