//
//  registrationDao.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"

@interface registrationDao : BaseDao 

- (BOOL) activateUser: (NSMutableArray *)dataSource;

- (BOOL) updatePCPUserRegistration: (NSMutableArray *)dataSource;

- (BOOL) updateHospitalistRegistration: (NSMutableArray *)dataSource;

- (NSDictionary *) getRegisteredUser;

@end
