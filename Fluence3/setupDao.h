//
//  setupDao.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDao.h"
#import "IreferConstraints.h"
#include <string.h>

@interface setupDao : BaseDao

- (BOOL)savePractices:(NSMutableArray *)dataList;
- (BOOL)saveHospitals:(NSMutableArray *)dataList;
- (BOOL)saveInsurances:(NSMutableArray *)dataList;
- (BOOL)saveSpecialities:(NSMutableArray *)dataList;
- (BOOL)saveCounties:(NSMutableArray *)dataList;
- (BOOL)saveDoctors:(NSMutableArray *)dataList;


- (BOOL)clearAllSettings;
- (BOOL)clearDoctors;
- (BOOL)clearPractices;
- (BOOL)clearHospitals;

@end
