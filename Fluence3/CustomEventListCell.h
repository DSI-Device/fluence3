//
//  customSelectCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomEventListCell : UITableViewCell {
	
	IBOutlet NSString *eventID;
    IBOutlet UILabel *eventName;
    IBOutlet UIButton *joined;
	IBOutlet UIImageView *eventImage;
	BOOL isJoined;
}

@property(nonatomic, retain) NSString *eventID;
@property(nonatomic, retain) UILabel *eventName;
@property(nonatomic, retain) UIButton *joined;
@property(nonatomic, retain) UIImageView *eventImage;
@property(nonatomic, assign) BOOL isJoined;
-(IBAction)cellButtonClick:(id)sender;
@end
