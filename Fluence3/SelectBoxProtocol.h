//
//  filterDelegate.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SelectBoxProtocol
	
- (void) setSelectedOption:(NSMutableArray *)dataSet delegate:(UIViewController *)controller;

@end
