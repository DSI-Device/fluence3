//
//  searchDao.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"
#import "utils.h"

@interface searchDao : BaseDao {

}

- (NSMutableArray *) getDoctorList:(NSString *)docName insIds:(NSString *)insIds hosIds:(NSString *)hosIds spIds:(NSString *)spIds pracIds:(NSString *)pracIds countyIds:(NSString *)countyIds languages:(NSString *)languages officeHours:(NSString *)officeHours zip:(NSString *)zipCode inPatient:(NSString *)inPatient order:(int)order limit:(int)limit;

- (NSDictionary *) getDoctorDetails:(NSString *)docId;

- (NSMutableArray *) getAdvDoctorList:(NSString *)searchCode order:(int)order limit:(int)limit;

- (BOOL) updateDoctorRank:(int)docId rank:(int)rankValue;

- (NSArray *) getReportListByDoctor:(NSString *)docId;

- (BOOL) updateDoctorChangeReport:(NSString *)docId userId:(NSString *)uId content:(NSString *)msg;

- (void) updateSearchCount:(int)type;

@end
