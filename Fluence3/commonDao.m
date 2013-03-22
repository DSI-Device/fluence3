//
//  commonDao.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "commonDao.h"


@implementation commonDao

-(BOOL) clearUsers{
	
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSString *deleteSQL = @"DELETE FROM t_users";
		sqlite3_stmt *delStmt;
		sqlite3_prepare_v2(database, [deleteSQL UTF8String], -1, &delStmt, nil);
		if(sqlite3_step(delStmt) != SQLITE_DONE){
			NSLog(@"unable to delete from user table");
			sqlite3_finalize(delStmt);
			sqlite3_close(database);
			return NO;
		}	
		sqlite3_finalize(delStmt);
		sqlite3_close(database);
		return YES;
	}else {
		NSLog(@"Unable to open database connection");
		return NO;
	}	
}

-(BOOL) clearPractices{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSString *deleteSQL = @"DELETE FROM t_practice";
		sqlite3_stmt *delStmt;
		sqlite3_prepare_v2(database, [deleteSQL UTF8String], -1, &delStmt, nil);
		if(sqlite3_step(delStmt) != SQLITE_DONE){
			NSLog(@"unable to delete from practice table");
			sqlite3_finalize(delStmt);
			sqlite3_close(database);
			return NO;
		}	
		sqlite3_finalize(delStmt);
		sqlite3_close(database);
		return YES;
	}else {
		NSLog(@"Unable to open database connection");
		return NO;
	}	
}

@end
