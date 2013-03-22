//
//  commonDao.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"

@interface commonDao : BaseDao 

- (BOOL) clearUsers;
- (BOOL) clearPractices;
- (BOOL) clearHospitals;
- (BOOL) clearCounties;

@end
