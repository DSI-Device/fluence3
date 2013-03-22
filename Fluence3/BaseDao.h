//
//  BaseDao.h
//  irefer2
//
//  Created by Mushraful Hoque on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "IreferConstraints.h"
#import "utils.h"

#define databaseFileName @"/irefer.sqlite3.db"

@interface BaseDao : NSObject {
	@protected sqlite3 *database;
}

- (NSString *)dataFilePath;

- (void)initializeTables;

- (BOOL)isUserAlreadyActivated;

- (NSDictionary *) getCurrentUser;

- (NSDictionary *) getCurrentUserPracticeOrHospital;

- (BOOL) isUserPCP;

- (NSUInteger *)getTableRowCount:(NSString *)tableName;

- (NSUInteger *)getTableRowCount:(NSString *)tableName searchValue:(NSString *)name;

- (NSUInteger *)getTableRowCount:(NSString *)tableName colName:(NSString *)column;

- (BOOL)deleteTableRow:(NSString *)tableName columnName:(NSString *)colName rowIndex:(int)rid;

- (NSMutableArray *)getTableRowList:(NSString *)tableName searchValue:(NSString *)name;

- (NSMutableArray *)getTableRowList:(NSString *)tableName searchValue:(NSString *)name limit:(int)limit;

- (BOOL) updateUserSyncFlag:(NSString *)flag;

- (NSArray *)getSyncronizableReports;

- (void) updateSyncronizableReports;

- (NSArray *)getSyncronizableRanks;

- (void) updateSyncronizableRanks;

- (int) getSearchCount:(int)type;

- (BOOL) updateFlagSyncProcessDone;

- (BOOL) updateProfile:(NSDictionary *)newUserData;

- (BOOL) updateNotifyDates:(NSString *)uid adminNotifyDate:(NSString *)adminNotifyDate userNotifyDate:(NSString *)userNotifyDate;


@end
