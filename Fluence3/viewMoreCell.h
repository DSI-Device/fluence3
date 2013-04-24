//
//  viewMoreCell.h
//  irefer2
//
//  Created by Mushraful Hoque on 2/16/12.
//  Copyright 2012 Dynamic Solution Innovators Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface viewMoreCell : UITableViewCell {

	IBOutlet UILabel *showMessage;
	IBOutlet UILabel *moreCountMessage;
}

@property (nonatomic,retain) UILabel *showMessage;
@property (nonatomic,retain) UILabel *moreCountMessage;


@end
