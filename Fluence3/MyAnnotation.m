//
//  MyAnnotation.m
//  SimpleMapView
//
//  Created by Mayur Birari .

//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize title;
@synthesize uniqueId;
@synthesize subtitle;
@synthesize coordinate;
@synthesize imageUrl;

- (void)dealloc 
{
	[super dealloc];
	self.title = nil;
	self.subtitle = nil;
    self.uniqueId = nil;
    self.imageUrl = nil;
}
@end