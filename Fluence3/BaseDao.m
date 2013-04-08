//
//  BaseDao.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDao.h"


@implementation BaseDao

- (NSString *)dataFilePath{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:databaseFileName];
	
}

- (void)initializeTables{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		char *errorMsg;
		
		NSArray *queries = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"irefer_ddl" ofType:@"sql"] usedEncoding:nil error:nil] componentsSeparatedByString:@"\n"];

		[queries objectAtIndex:3];
		for( NSString *createSQL in queries){
			NSLog(@"current sql : %@",createSQL);	
			if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				sqlite3_close(database);
				NSAssert1(0, @"Error while initializing tables : %s", errorMsg);
			}
			
		}
		
		sqlite3_close(database);
		NSLog(@"irefer DDL successfully updated on sqlite3");
	}
	
}


- (BOOL)isUserAlreadyActivated{

	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSString *query = @"SELECT count(*) from t_users where act_code <> ''";
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			if (sqlite3_step(statement) == SQLITE_ROW) {
				int count = sqlite3_column_int(statement, 0);
				NSLog(@"activated user count: %d",count);
				if (count > 0) {
					sqlite3_finalize(statement);
					sqlite3_close(database);
					return YES;
				}
			}
				
		}else {
			NSLog(@"error on select query ");
		}

		sqlite3_finalize(statement);
		sqlite3_close(database);
		NSLog(@"irefer DDL successfully updated on sqlite3");
	}
	 return NO;
	
}

- (NSDictionary *) getCurrentUser{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSString *query = @"SELECT user_id, last_name, first_name, email, need_to_sync, update_setting from t_users where act_code <> ''";
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			if(sqlite3_step(statement) == SQLITE_ROW) {
				
				int uId = sqlite3_column_int(statement, 0);
				NSString *lastName = [NSString stringWithUTF8String:sqlite3_column_text(statement, 1)];
				NSString *firstName = [NSString stringWithUTF8String:sqlite3_column_text(statement, 2)];
				NSString *email = [NSString stringWithUTF8String:sqlite3_column_text(statement, 3)];
				int needToSync = sqlite3_column_int(statement, 4);
				int updateSetting = sqlite3_column_int(statement, 5);
	
				
				sqlite3_finalize(statement);
				sqlite3_close(database);
				
				return [[[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithFormat:@"%d",uId], @"id", lastName, @"last_name", firstName, @"first_name", email, @"email", [NSString stringWithFormat:@"%d",needToSync], @"need_to_sync", [NSString stringWithFormat:@"%d",updateSetting], @"update_setting", nil] autorelease];
				
			}
			
		}else {
			NSLog(@"error on select query [getCurrentUserPracticeOrHospital]");
		}
		
		sqlite3_close(database);
		NSLog(@"irefer DDL successfully done[getCurrentUserPracticeOrHospital] on sqlite3");
		
	}
	
	return nil;	
}


- (NSDictionary *) getCurrentUserPracticeOrHospital{
	
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSString *query = @"SELECT user_id, last_name, first_name, my_prac_id, my_hos_id, my_county_id, need_to_sync, last_sync_time, last_admin_sync_time from t_users where act_code <> ''";
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			if(sqlite3_step(statement) == SQLITE_ROW) {
				
				
				NSString *uId = [NSString stringWithUTF8String:sqlite3_column_text(statement, 0)];
				NSString *lastName = [NSString stringWithUTF8String:sqlite3_column_text(statement, 1)];
				NSString *firstName = [NSString stringWithUTF8String:sqlite3_column_text(statement, 2)];
				NSString *needToSync = [NSString stringWithUTF8String:sqlite3_column_text(statement, 6)];
				NSString *lastSyncTime = @""; 
				const char *time = sqlite3_column_text(statement, 7);
				if( time != NULL ){
					lastSyncTime = [NSString stringWithUTF8String:time];
				}
				NSString *lastAdmSyncTime = @"";
				time = sqlite3_column_text(statement, 8);
				if( time != NULL ){
					lastAdmSyncTime = [NSString stringWithUTF8String:time];
				}
					
				NSString *pracName = nil;
				NSString *pracAddr = nil;
				
				int pracId = sqlite3_column_int(statement, 3);
				int hosId = sqlite3_column_int(statement, 4);
				int countyId = sqlite3_column_int(statement, 5);
				
				sqlite3_finalize(statement);
				
				NSString *countyName = @"";
				NSString *countyState = @"";
				if( countyId > 0 ){
					query = @"SELECT name, state_code from t_county where county_id =  ?";
					sqlite3_stmt *stmt;
					
					if(sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK){
						sqlite3_bind_int(stmt, 1, countyId);
						
						if(sqlite3_step(stmt) == SQLITE_ROW) {
							const char *countyNm = sqlite3_column_text(stmt, 0);
							if( countyNm != NULL ){
								countyName = [NSString stringWithUTF8String:countyNm];
							}
							const char *stateNm = sqlite3_column_text(stmt, 1);
							if( stateNm != NULL ){
								countyState = [NSString stringWithUTF8String:stateNm];
							}
						}
						
						sqlite3_finalize(stmt);
					}
				}
				
				int rid = 0;
				int isPCP = 1;
				
				if (pracId > 0) {
					query = @"SELECT name, address from t_practice where prac_id =  ?";
					sqlite3_stmt *stmt;
					
					if(sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK){
						sqlite3_bind_int(stmt, 1, pracId);
						
						if(sqlite3_step(stmt) == SQLITE_ROW) {
							rid = pracId;
							const char *procNm = sqlite3_column_text(stmt, 0);
							if (procNm == NULL) {
								pracName = nil;
							}else {
								pracName = [NSString stringWithUTF8String:procNm];
							}
							
							const char *procAd = sqlite3_column_text(stmt, 1);
							if (procAd == NULL) {
								pracAddr = nil;
							}else {
								pracAddr = [NSString stringWithUTF8String:procAd];
							}
						}
						
						sqlite3_finalize(stmt);
						
					}
					
				}else {
					if (hosId >0) {
						query = @"SELECT name, address from t_hospital where hos_id =  ?";
						sqlite3_stmt *stmt;
						
						if(sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK){
							sqlite3_bind_int(stmt, 1, hosId);
							
							if(sqlite3_step(stmt) == SQLITE_ROW) {
								rid = hosId;
								isPCP = 0;
								const char *procNm = sqlite3_column_text(stmt, 0);
								if (procNm == NULL) {
									pracName = nil;
								}else {
									pracName = [NSString stringWithUTF8String:procNm];
								}
								
								const char *procAd = sqlite3_column_text(stmt, 1);
								if (procAd == NULL) {
									pracAddr = nil;
								}else {
									pracAddr = [NSString stringWithUTF8String:procAd];
								}
							}
							
							sqlite3_finalize(stmt);
							
						}
						
					}
					
					//--------//
				}
				/*
				query = @"SELECT distinct(county_id) from t_doctor";
				statement;
				
				if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
					
					while (sqlite3_step(statement) == SQLITE_ROW) {
						int count = sqlite3_column_int(statement, 0);
						NSLog(@"doctor count : %d",count);
					}
					
				}else {
					NSLog(@"error on select query ");
				}
				
				sqlite3_finalize(statement);
				*/
				sqlite3_close(database);
				//NSLog(@"sate name %@",countyState);
				return [[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithFormat:@"%d",rid], @"id", pracName, @"prac_name", pracAddr, @"prac_addr", [NSString stringWithFormat:@"%d",isPCP], @"is_PCP",
						uId, @"uid", lastName, @"last_name", firstName, @"first_name", countyName, @"county_name", [NSString stringWithFormat:@"%d", countyId], @"county_id", needToSync, @"need_to_sync", countyState, @"state_code",
						lastSyncTime, @"last_sync_time", lastAdmSyncTime, @"last_admin_sync_time", nil];
				
			}
			
		}else {
			NSLog(@"error on select query [getCurrentUserPracticeOrHospital]");
		}
		
		sqlite3_close(database);
		NSLog(@"irefer DDL successfully done[getCurrentUserPracticeOrHospital] on sqlite3");
		
	}
	
	return nil;
}

- (BOOL) isUserPCP{
	
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSString *query = @"SELECT count(*) from t_users where my_prac_id > 0";
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			if (sqlite3_step(statement) == SQLITE_ROW) {
				int count = sqlite3_column_int(statement, 0);
				NSLog(@"PCP user count: %d",count);
				if (count > 0) {
					sqlite3_finalize(statement);
					sqlite3_close(database);
					return YES;
				}
			}
			
		}else {
			NSLog(@"error on select query ");
		}
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
		NSLog(@"irefer DDL successfully updated on sqlite3");
	}
	
	return NO;
}


- (NSMutableArray *)getTableRowList:(NSString *)tableName searchValue:(NSString *)pname{
	
	if(pname == nil || [pname isEqual:@""])
		pname = @"%";
	else 
		pname = [[@"%" stringByAppendingString:pname] stringByAppendingString:@"%"];
	
	
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
		
		NSString *query = [NSString stringWithFormat: @"SELECT * from %@ where name like '%@' order by name", tableName, pname];
		NSLog(@"query : %@",query);
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				NSString *pid = [NSString stringWithUTF8String: sqlite3_column_text(statement, 0)];
				NSString *name = [NSString stringWithUTF8String: sqlite3_column_text(statement, 1)];
				
				NSString *address;
				int groupId;
				
				if( [tableName isEqual:IreferConstraints.specialityTableName] ){
					groupId = sqlite3_column_int(statement, 2);
				}else if( [tableName isEqual:IreferConstraints.countyTableName] ){
					
					const char *cntNm = sqlite3_column_text(statement, 3);
					if (cntNm == NULL) {
						address = @"";
					}else {
						address = [NSString stringWithUTF8String:cntNm];
					}
					
				}else {
					address = [NSString stringWithUTF8String: sqlite3_column_text(statement, 2)];
				}
				
				if( [tableName isEqual:IreferConstraints.specialityTableName] ){
					[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: pid, @"id", name, @"name", [NSString stringWithFormat:@"%d", groupId], @"group_id", nil] autorelease]];
				}else if( [tableName isEqual:IreferConstraints.countyTableName] ){
					[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: pid, @"id", name, @"name", address, @"state_code", nil] autorelease]];
				}else {
					[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: pid, @"id", name, @"name", address, @"add_line1", @"", @"add_line2", nil] autorelease]];
				}
				
				
			}
			
		}else {
			NSLog(@"error on select query [getTableRowList-%@] on setup dao",tableName);
			sqlite3_finalize(statement);	
			sqlite3_close(database);
			return nil;
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		NSLog(@"irefer DDL successfully done[getTableRowList-%@] on setup dao",tableName);
		return array;
	}else {
		NSLog(@"unable to open database ");

	}

	return nil;
	
}

- (NSMutableArray *)getTableRowList:(NSString *)tableName searchValue:(NSString *)pname limit:(int)limit{

	if(pname == nil || [pname isEqual:@""])
		pname = @"%";
	else 
		pname = [[@"%" stringByAppendingString:pname] stringByAppendingString:@"%"];
	
	
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
		
		NSString *query = [NSString stringWithFormat: @"SELECT * from %@ where name like '%@' order by name limit %d", tableName, pname, limit];
		NSLog(@"query : %@",query);
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				NSString *pid = [NSString stringWithUTF8String: sqlite3_column_text(statement, 0)];
				NSString *name = [NSString stringWithUTF8String: sqlite3_column_text(statement, 1)];
				
				NSString *address;
				int groupId;
				
				if( [tableName isEqual:IreferConstraints.specialityTableName] ){
					groupId = sqlite3_column_int(statement, 2);
				}else if( [tableName isEqual:IreferConstraints.countyTableName] ){
					
					const char *cntNm = sqlite3_column_text(statement, 3);
					if (cntNm == NULL) {
						address = @"";
					}else {
						address = [NSString stringWithUTF8String:cntNm];
					}
					
				}else {
					address = [NSString stringWithUTF8String: sqlite3_column_text(statement, 2)];
				}
				
				if( [tableName isEqual:IreferConstraints.specialityTableName] ){
					[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: pid, @"id", name, @"name", [NSString stringWithFormat:@"%d", groupId], @"group_id", nil] autorelease]];
				}else if( [tableName isEqual:IreferConstraints.countyTableName] ){
					[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: pid, @"id", name, @"name", address, @"state_code", nil] autorelease]];
				}else {
					[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: pid, @"id", name, @"name", address, @"add_line1", @"", @"add_line2", nil] autorelease]];
				}
				
				
			}
			
		}else {
			NSLog(@"error on select query [getTableRowList-%@] on setup dao",tableName);
			sqlite3_finalize(statement);	
			sqlite3_close(database);
			return nil;
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		NSLog(@"irefer DDL successfully done[getTableRowList-%@] on setup dao",tableName);
		return array;
	}else {
		NSLog(@"unable to open database ");
		
	}
	
	return nil;
	
}


- (NSUInteger *)getTableRowCount:(NSString *)tableName{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSUInteger *count = 0;
		
		NSString *query = [NSString stringWithFormat: @"SELECT count(*) from %@", tableName];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			if(sqlite3_step(statement) == SQLITE_ROW) {
				count = sqlite3_column_int(statement, 0);
			}else {
				NSLog(@"error on select query [getTableRowCount-%@] on setup dao",tableName);
			}
		}else {
			NSLog(@"error on select query [getTableRowCount-%@] on setup dao",tableName);
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		return count;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}
	return 0;
}

- (NSUInteger *)getTableRowCount:(NSString *)tableName searchValue:(NSString *)pname{
	if(pname == nil || [pname isEqual:@""])
		pname = @"%";
	else 
		pname = [[@"%" stringByAppendingString:pname] stringByAppendingString:@"%"];
	
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSUInteger *count = 0;
		
		NSString *query = [NSString stringWithFormat: @"SELECT count(*) from %@ where name LIKE '%@'", tableName, pname];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			if(sqlite3_step(statement) == SQLITE_ROW) {
				count = sqlite3_column_int(statement, 0);
			}else {
				NSLog(@"error on select query [getTableRowCount-%@] on setup dao",tableName);
			}
		}else {
			NSLog(@"error on select query [getTableRowCount-%@] on setup dao",tableName);
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		return count;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}
	return 0;
}

- (NSUInteger *)getTableRowCount:(NSString *)tableName colName:(NSString *)column{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSUInteger *count = 0;
		
		NSString *query = [NSString stringWithFormat: @"SELECT count(distinct(%@)) from %@", column, tableName];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			if(sqlite3_step(statement) == SQLITE_ROW) {
				count = sqlite3_column_int(statement, 0);
			}else {
				NSLog(@"error on select query [getTableRowCount-%@] on setup dao",tableName);
			}
		}else {
			NSLog(@"error on select query [getTableRowCount-%@] on setup dao",tableName);
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		return count;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}
	return 0;	
}

- (BOOL)deleteTableRow:(NSString *)tableName columnName:(NSString *)colName rowIndex:(int)rid{
	
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		BOOL status = YES;
		char *errorMsg;
		NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM %@ where %@=%d",tableName, colName, rid];
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			status = NO;
			NSLog(@"unable to delete all from deleteTableRow on setup dao...");
		}
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return status;
		
	}else {
		NSLog(@"Unable to open database connection on base dao....");
	}
	return NO;
}

- (BOOL) updateFlagSyncProcessDone{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		BOOL status = YES;
		char *errorMsg;
		NSString *updateSQL = [NSString stringWithFormat:@"update t_users set need_to_sync=0, last_sync_time='%@' where act_code <> ''", [utils getFormatedStringFromDate:[NSDate date]]];
		if(sqlite3_exec(database, [updateSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			status = NO;
			NSLog(@"unable to delete all from updateUserSyncFlag on base dao...");
		}
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return status;
		
	}else {
		NSLog(@"Unable to open database connection on base dao....");
	}
	return NO;	
}

- (BOOL) updateUserSyncFlag:(NSString *)flag{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		BOOL status = YES;
		char *errorMsg;
		NSString *updateSQL = [NSString stringWithFormat:@"update t_users set need_to_sync=%@ where act_code <> ''",flag];
		if(sqlite3_exec(database, [updateSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			status = NO;
			NSLog(@"unable to delete all from updateUserSyncFlag on base dao...");
		}
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return status;
		
	}else {
		NSLog(@"Unable to open database connection on base dao....");
	}
	return NO;
}

- (NSArray *)getSyncronizableReports{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];	

		NSString *query = [NSString stringWithFormat:@"SELECT doc_id, description FROM t_doc_report WHERE submit_time = ''"];
		
		NSLog(@"query : %@",query);
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithUTF8String: sqlite3_column_text(statement, 0)], @"docId", 
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 1)], @"text", nil] autorelease]];
			}
			
		}else {
			NSLog(@"error on select query [getSyncronizableReports] on search dao");
			sqlite3_finalize(statement);	
			sqlite3_close(database);
			return nil;
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		return array;				
		
	}else {
		NSLog(@"Unable to open database connection on base dao....");
	}
	return nil;
}

- (BOOL) updateSyncronizableReports{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		BOOL status = YES;
		char *errorMsg;
		NSString *updateSQL = [NSString stringWithFormat:@"update t_doc_report set submit_time=\"%@\" where submit_time=''",[utils getFormatedStringFromDate:[NSDate date]]];
		if(sqlite3_exec(database, [updateSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			status = NO;
			NSLog(@"unable to update from updateSyncronizableReports on base dao...");
		}
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return status;
		
	}else {
		NSLog(@"Unable to open database connection on base dao....");
	}
}

- (NSArray *)getSyncronizableRanks{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];	
		
		NSString *query = [NSString stringWithFormat:@"SELECT doc_id, u_rank FROM t_doctor WHERE rank_update=1"];
		
		NSLog(@"query : %@",query);
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithUTF8String: sqlite3_column_text(statement, 0)], @"docId", 
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 1)], @"rank", nil] autorelease]];
			}
			
		}else {
			NSLog(@"error on select query [getSyncronizableRanks] on search dao");
			sqlite3_finalize(statement);	
			sqlite3_close(database);
			return nil;
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		return array;				
		
	}else {
		NSLog(@"Unable to open database connection on base dao....");
	}
	return nil;
}

- (BOOL) updateSyncronizableRanks{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		BOOL status = YES;
		char *errorMsg;
		NSString *updateSQL = [NSString stringWithFormat:@"update t_doctor set rank_update=0 where rank_update=1"];
		if(sqlite3_exec(database, [updateSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			status = NO;
			NSLog(@"unable to update from updateSyncronizableReports on base dao...");
		}
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return status;
		
	}else {
		NSLog(@"Unable to open database connection on base dao....");
	}
	
}

- (int) getSearchCount:(int)type{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		
		NSString *query = [NSString stringWithFormat:@"SELECT count from t_statistics where count_type=%d",type];
		sqlite3_stmt *statement;
		
		int count = 0;
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			if(sqlite3_step(statement) == SQLITE_ROW) {
				
				count = sqlite3_column_int(statement, 0);
				
			}
		}else {
			NSLog(@"error on select query [getSearchCount]");
		}
		sqlite3_finalize(statement);		
		sqlite3_close(database);
		return count;		
		
	}else {
		NSLog(@"Unable to open database connection for user statistics....");
	}
	return 0;
}

- (BOOL) updateProfile:(NSDictionary *)newUserData{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {

		NSString *insertSQL;
		NSString *practiceId = @"0";
		NSString *hospitalId = @"0";
		char *errorMsg;
		NSDictionary *state = [newUserData objectForKey:@"state"];
		NSDictionary *county = [newUserData objectForKey:@"county"];

		if ([newUserData objectForKey:@"practice"] != nil) {
			NSDictionary *practice = [newUserData objectForKey:@"practice"];	
			practiceId = [practice objectForKey:@"id"];

			insertSQL = [ NSString stringWithFormat:@"INSERT OR REPLACE INTO t_practice SELECT %@ AS prac_id, \"%@\" AS name, \"%@\" AS address",
						 [practice objectForKey:@"id"], [practice objectForKey:@"name"], [NSString stringWithFormat:@"%@, %@, %@", [practice objectForKey:@"add_line_1"], [practice objectForKey:@"city"], [state objectForKey:@"state_code"]]];
			
		}else if ([newUserData objectForKey:@"hospital"] != nil) {
			NSDictionary *hospital = [newUserData objectForKey:@"hospital"];	
			hospitalId = [hospital objectForKey:@"id"];
			
			insertSQL = [ NSString stringWithFormat:@"INSERT OR REPLACE INTO t_hospital SELECT %@ AS hos_id, \"%@\" AS name, \"%@\" AS address",
						 [hospital objectForKey:@"id"], [hospital objectForKey:@"name"], [hospital objectForKey:@"add_line_1"]];
						
		}
		
		if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
			
			NSLog(@"unable to insert practice/hospital on updateProfile %s",errorMsg);
		}
		sqlite3_free(errorMsg);

		insertSQL = [NSString stringWithFormat:@"update t_users set first_name=\"%@\", last_name=\"%@\", my_prac_id=%@, my_hos_id=%@, my_county_id=%@  where user_id=%@ ",
					 [newUserData objectForKey:@"first_name"], [newUserData objectForKey:@"last_name"], practiceId, hospitalId,
					 [county objectForKey:@"id"], [newUserData objectForKey:@"user_id"] ];

		if(sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to update user data on updateProfile...");
		}
		sqlite3_free(errorMsg);
		
		
		insertSQL = [NSString stringWithFormat:@"DELETE FROM t_county where county_id=(select my_county_id from t_users where act_code <> '');"];
		if(sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete from delete county on updateProfile...");
		}
		sqlite3_free(errorMsg);
		
		
		insertSQL = [ NSString stringWithFormat:@"INSERT OR REPLACE INTO t_county SELECT %d AS county_id, \"%@\" AS name, \"%@\" AS code, \"%@\" AS state_code",
					 [[county objectForKey:@"id"] integerValue], [county objectForKey:@"name"], @"", [state objectForKey:@"state_code"]];
		
		if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
			
			NSLog(@"unable to insert county on updateProfile %s",errorMsg);
		}
		
		
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return YES;
	}else {
		NSLog(@"Unable to open database connection for user updateProfile....");
	}
	return NO;
}

- (BOOL) updateNotifyDates:(NSString *)uid adminNotifyDate:(NSString *)adminNotifyDate userNotifyDate:(NSString *)userNotifyDate{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		char *errorMsg;
		NSString *updateSQL = [NSString stringWithFormat:@"update t_users set last_admin_sync_time=\"%@\", last_sync_time=\"%@\", need_to_sync=0 where user_id=%@", adminNotifyDate, userNotifyDate, uid];
		if(sqlite3_exec(database, [updateSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to update from updateNotifyDates on base dao...%s",errorMsg);
		}
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return YES;
		
	}else {
		NSLog(@"Unable to open database connection on updateNotifyDates....");
	}
}

@end
