//
//  customSelectCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomWeatherListCell : UITableViewCell {
	
	IBOutlet NSString *weatherID;
    IBOutlet UILabel *weatherName;
    
}

@property(nonatomic, retain) NSString *weatherID;
@property(nonatomic, retain) UILabel *weatherName;

@end
