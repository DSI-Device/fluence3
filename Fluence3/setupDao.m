    //
//  setupDao.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "setupDao.h"


@implementation setupDao


- (BOOL)savePractices:(NSMutableArray *)dataList{
	if(dataList == nil || [dataList count] == 0)
		return YES;
	
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		NSString *deleteSQL = @"DELETE FROM t_practice where prac_id NOT IN (select my_prac_id from t_users where act_code <> '')";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete all from practice table on setup dao...");
		}
	
		NSString *insertSQL;
		NSAutoreleasePool *pool;
		BOOL *isFirst = YES;
		int i = 1;
		for(NSDictionary *dict in dataList){
						
			if (isFirst) {
				isFirst = NO;
				pool = [[NSAutoreleasePool alloc] init]; 
				insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO t_practice SELECT %d AS prac_id, \"%@\" AS name, \"%@\" AS address",
							  [[dict objectForKey:@"id"] integerValue], [dict objectForKey:@"name"], [dict objectForKey:@"add_line_1"]];
			}else {
				
				insertSQL = [ insertSQL stringByAppendingFormat:@" UNION SELECT %d, \"%@\", \"%@\"",
							 [[dict objectForKey:@"id"] integerValue], [dict objectForKey:@"name"], [dict objectForKey:@"add_line_1"]];				
			}
			
			if (i%500 == 0) {
				if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
					
					NSLog(@"unable to insert practice on setup dao %s",errorMsg);
				}
				
				isFirst = YES;
				[pool drain];
			}
			
			i++;
			
		}
		
		if (!isFirst) {
			if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				
				NSLog(@"unable to insert practice on setup dao %s",errorMsg);
			}		
			[pool drain];
		}
		
		sqlite3_free(errorMsg);		
	    sqlite3_close(database);
		NSLog(@"successfully saved practices on setup dao");
		return YES;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}	
	return NO;
}

- (BOOL)saveHospitals:(NSMutableArray *)dataList{
	if(dataList == nil || [dataList count] == 0)
		return YES;
	
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		NSString *deleteSQL = @"DELETE FROM t_hospital where hos_id <> (select my_hos_id from t_users where act_code <> '')";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete all from hospital table on setup dao...%s",errorMsg);
		}

		NSString *insertSQL;
		NSAutoreleasePool *pool;
		BOOL *isFirst = YES;
		int i = 1;
		for(NSDictionary *dict in dataList){
			
			if (isFirst) {
				isFirst = NO;
				pool = [[NSAutoreleasePool alloc] init]; 
				insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO t_hospital SELECT %d AS hos_id, \"%@\" AS name, \"%@\" AS address",
							 [[dict objectForKey:@"id"] integerValue], [dict objectForKey:@"name"], [dict objectForKey:@"add_line1"]];
			}else {
				
				insertSQL = [ insertSQL stringByAppendingFormat:@" UNION SELECT %d, \"%@\", \"%@\"",
							 [[dict objectForKey:@"id"] integerValue], [dict objectForKey:@"name"], [dict objectForKey:@"add_line1"]];				
			}
			
			if (i%500 == 0) {
				if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
					
					NSLog(@"unable to insert hospital on setup dao %s",errorMsg);
				}
				
				isFirst = YES;
				[pool drain];
			}
			
			i++;
			
		}
		
		if (!isFirst) {
			if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				
				NSLog(@"unable to insert hospital on setup dao %s",errorMsg);
			}		
			[pool drain];
		}
		
		sqlite3_free(errorMsg);		
	    sqlite3_close(database);
		NSLog(@"successfully saved hospital on setup dao");
		return YES;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}	
	return NO;
}

- (BOOL)saveInsurances:(NSMutableArray *)dataList{
	if(dataList == nil || [dataList count] == 0)
		return YES;
	
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		NSString *deleteSQL = @"DELETE FROM t_insurance";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete all from insurance table on setup dao...");
		}
		
		NSString *insertSQL;
		NSAutoreleasePool *pool;
		BOOL *isFirst = YES;
		int i = 1;
		for(NSDictionary *dict in dataList){
			
			if (isFirst) {
				isFirst = NO;
				pool = [[NSAutoreleasePool alloc] init]; 
				insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO t_insurance SELECT %d AS ins_id, \"%@\" AS name, \"%@\" AS address",
							 [[dict objectForKey:@"id"] integerValue], [dict objectForKey:@"name"], @""];
			}else {
				
				insertSQL = [ insertSQL stringByAppendingFormat:@" UNION SELECT %d, \"%@\", \"%@\"",
							 [[dict objectForKey:@"id"] integerValue], [dict objectForKey:@"name"], @""];				
			}
			
			if (i%500 == 0) {
				if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
					
					NSLog(@"unable to insert insurance on setup dao %s",errorMsg);
				}
				
				isFirst = YES;
				[pool drain];
			}
			
			i++;
			
		}
		
		if (!isFirst) {
			if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				
				NSLog(@"unable to insert insurance on setup dao %s",errorMsg);
			}			
			[pool drain];
		}
		
		sqlite3_free(errorMsg);		
	    sqlite3_close(database);
		NSLog(@"successfully saved insurance on setup dao");
		return YES;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}	
	return NO;
}

- (BOOL)saveSpecialities:(NSMutableArray *)dataList{
	if(dataList == nil || [dataList count] == 0)
		return YES;
	
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		NSString *deleteSQL = @"DELETE FROM t_speciality";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete all from speciality table on setup dao...");
		}
				
		NSString *insertSQL;
		NSAutoreleasePool *pool;
		BOOL *isFirst = YES;
		int i = 1;
		int spGroup = 0;
		for(NSDictionary *dict in dataList){
			if([dict objectForKey:@"group_id"] == [NSNull null])
				spGroup = 0;
			else {
				spGroup = [[dict objectForKey:@"group_id"] intValue]; 
			}
			
			if (isFirst) {
				isFirst = NO;
				pool = [[NSAutoreleasePool alloc] init]; 
				insertSQL = [ NSString stringWithFormat:@"INSERT OR REPLACE INTO t_speciality SELECT %d AS spec_id, \"%@\" AS name, %d AS spec_type",
							 [[dict objectForKey:@"id"] integerValue], [dict objectForKey:@"name"], spGroup];
			}else {
				
				insertSQL = [ insertSQL stringByAppendingFormat:@" UNION SELECT %d, \"%@\", %d",
							 [[dict objectForKey:@"id"] integerValue], [dict objectForKey:@"name"], spGroup];				
			}
			
			if (i%500 == 0) {
				if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
					
					NSLog(@"unable to insert speciality on setup dao %s",errorMsg);
				}
				
				isFirst = YES;
				[pool drain];
			}
			
			i++;
			
		}
		
		if (!isFirst) {
			if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				
				NSLog(@"unable to insert speciality on setup dao %s",errorMsg);
			}		
			[pool drain];
		}
		
		sqlite3_free(errorMsg);		
		sqlite3_close(database);
		NSLog(@"successfully saved speciality on setup dao");
		return YES;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}	
	return NO;
}

- (BOOL)saveCounties:(NSMutableArray *)dataList{
	if(dataList == nil || [dataList count] == 0)
		return YES;
	
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		NSString *deleteSQL = @"DELETE FROM t_county where county_id <> (select my_county_id from t_users where act_code <> '')";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete all from county table on setup dao...");
		}
		
		NSString *insertSQL;
		NSAutoreleasePool *pool;
		BOOL *isFirst = YES;
		int i = 1;
		for(NSDictionary *dict in dataList){
			
			if (isFirst) {
				isFirst = NO;
				pool = [[NSAutoreleasePool alloc] init]; 
				insertSQL = [ NSString stringWithFormat:@"INSERT OR REPLACE INTO t_county SELECT %d AS county_id, \"%@\" AS name, \"%@\" AS code, \"%@\" AS state_code",
							 [[dict objectForKey:@"id"] integerValue], [dict objectForKey:@"name"], @"", [dict objectForKey:@"state_code"]];
			}else {
				
				insertSQL = [ insertSQL stringByAppendingFormat:@" UNION SELECT %d, \"%@\", \"%@\", \"%@\"",
							 [[dict objectForKey:@"id"] integerValue], [dict objectForKey:@"name"], @"", [dict objectForKey:@"state_code"]];				
			}
			
			if (i%500 == 0) {
				if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
					
					NSLog(@"unable to insert county on setup dao %s",errorMsg);
				}
				
				isFirst = YES;
				[pool drain];
			}
			
			i++;
			
		}
		
		if (!isFirst) {
			if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				
				NSLog(@"unable to insert county on setup dao %s",errorMsg);
			}		
			[pool drain];
		}
		
		sqlite3_free(errorMsg);		
		sqlite3_close(database);
		NSLog(@"successfully saved county on setup dao");
		return YES;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}	
	return NO;
}

- (BOOL)saveDoctors:(NSMutableArray *)dataList{
	if(dataList == nil || [dataList count] == 0)
		return YES;
	if([dataList count] == 1 && [[[dataList objectAtIndex:0] objectForKey:@"id"] isEqual:@"0"])
		return YES;
	
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		NSString *deleteSQL = @"DELETE FROM t_doctor";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete all from doctor table on setup dao...");
		}
		NSString *insertSQL;
		NSAutoreleasePool *pool;
		BOOL *isFirst = YES;
		int i = 1;
		for(NSDictionary *dict in dataList){
		/*	
			if ([[dict objectForKey:@"u_rank"] isEqual:@""]) {
				[dict setValue:@"0" forKey:@"u_rank"];
			}
			if ([[dict objectForKey:@"up_rank"] isEqual:@""]) {
				[dict setValue:@"0" forKey:@"up_rank"];
			}
		*/	
			if (isFirst) {
				isFirst = NO;
				pool = [[NSAutoreleasePool alloc] init];  
				insertSQL = [ NSString stringWithFormat:@"INSERT INTO t_doctor SELECT \"%@\" AS doc_id, \"%@\" AS last_name, \"%@\" AS first_name, \"%@\" AS mid_name, \"%@\" AS degree, \"%@\" AS doc_phone, \"%@\" AS language, \"%@\" AS grade, \"%@\" AS gender, \"%@\" AS image_url, \"%@\" AS zip_code, \"%d\" AS res_flag, \"%@\" AS see_patient, \"%@\" AS doc_fax, \"%@\" AS npi, \"%@\" AS office_hour, \"%@\" AS u_rank, \"%@\" AS up_rank, \"%@\" AS prac_id, \"%@\" AS hos_id, \"%@\" AS spec_id, \"%@\" AS ins_id, \"%@\" AS county_id, \"0\" AS rank_update, \"%@\" AS quality, \"%@\" AS cost, \"%@\" AS rank_user_number, \"%@\" AS avg_rank ",
							 [dict objectForKey:@"id"], [dict objectForKey:@"c1"], [dict objectForKey:@"c2"],
							 [dict objectForKey:@"c3"], [dict objectForKey:@"c4"], [dict objectForKey:@"c5"], [dict objectForKey:@"c6"], [dict objectForKey:@"c7"],
							 [dict objectForKey:@"c8"], [dict objectForKey:@"c9"], [dict objectForKey:@"c19"], 0, [dict objectForKey:@"c13"], [dict objectForKey:@"c11"],
							 [dict objectForKey:@"c10"], [dict objectForKey:@"c12"], [dict objectForKey:@"u_rank"], [dict objectForKey:@"up_rank"],
							 [dict objectForKey:@"c14"], [dict objectForKey:@"c16"], [dict objectForKey:@"c15"], [dict objectForKey:@"c17"], [dict objectForKey:@"c18"],
							 [dict objectForKey:@"c21"], [dict objectForKey:@"c22"], [dict objectForKey:@"c23"], [dict objectForKey:@"c24"]];
			}else {
				
				insertSQL = [ insertSQL stringByAppendingFormat:@" UNION SELECT \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"0\", \"%@\", \"%@\", \"%@\", \"%@\"",
							 [dict objectForKey:@"id"], [dict objectForKey:@"c1"], [dict objectForKey:@"c2"],
							 [dict objectForKey:@"c3"], [dict objectForKey:@"c4"], [dict objectForKey:@"c5"], [dict objectForKey:@"c6"], [dict objectForKey:@"c7"],
							 [dict objectForKey:@"c8"], [dict objectForKey:@"c9"], [dict objectForKey:@"c19"], 0, [dict objectForKey:@"c13"], [dict objectForKey:@"c11"],
							 [dict objectForKey:@"c10"], [dict objectForKey:@"c12"], [dict objectForKey:@"u_rank"], [dict objectForKey:@"up_rank"],
							 [dict objectForKey:@"c14"], [dict objectForKey:@"c16"], [dict objectForKey:@"c15"], [dict objectForKey:@"c17"], [dict objectForKey:@"c18"], 
							 [dict objectForKey:@"c21"], [dict objectForKey:@"c22"], [dict objectForKey:@"c23"], [dict objectForKey:@"c24"]];				
			}
			
			if (i%500 == 0) {
				
				if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
					
					NSLog(@"unable to insert doctor on setup dao %s",errorMsg);
				}
				//NSLog(@"saved...");
				isFirst = YES;
				[pool drain];
				
			}
			
			i++;
		
		}
				
		if (!isFirst) {
			if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				
				NSLog(@"unable to insert doctor on setup dao %s",errorMsg);
			}	
			[pool drain];
		}

		sqlite3_free(errorMsg);
	    sqlite3_close(database);
		NSLog(@"successfully saved doctors on setup dao");
		return YES;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}	
	return NO;	
}


- (BOOL)clearAllSettings{
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSString *query = @"SELECT my_prac_id, my_hos_id, my_county_id from t_users where act_code <> ''";
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			if(sqlite3_step(statement) == SQLITE_ROW) {
				
				int pracId = sqlite3_column_int(statement, 0);
				int hosId = sqlite3_column_int(statement, 1);
				int countyId = sqlite3_column_int(statement, 2);
				
				sqlite3_finalize(statement);		

				char *errorMsg;
				NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM t_practice where prac_id <> %d",pracId];
				if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
					NSLog(@"unable to delete all from practice table on setup dao...");
				}
				deleteSQL = [NSString stringWithFormat:@"DELETE FROM t_hospital where hos_id <> %d",hosId];
				if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
					NSLog(@"unable to delete all from hospital table on setup dao...");
				}
				deleteSQL = @"DELETE FROM t_insurance";
				if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
					NSLog(@"unable to delete all from insurance table on setup dao...");
				}
				deleteSQL = @"DELETE FROM t_speciality";
				if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
					NSLog(@"unable to delete all from speciality table on setup dao...");
				}
				deleteSQL = [NSString stringWithFormat:@"DELETE FROM t_county where county_id <> %d",countyId];
				if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
					NSLog(@"unable to delete all from county table on setup dao...");
				}
				deleteSQL = @"DELETE FROM t_doctor";
				if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
					NSLog(@"unable to delete all from doctor table on setup dao...");
				}
				
				sqlite3_free(errorMsg);
				sqlite3_close(database);
				return YES;
			}
		}else {
			NSLog(@"error on select query [clearAllSettings]");
		}
		
		sqlite3_finalize(statement);				
		sqlite3_close(database);
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}		
	return NO;
}

- (BOOL)clearDoctors{
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM t_doctor"];
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete all from doctor table on setup dao...");
			
			sqlite3_free(errorMsg);
			sqlite3_close(database);
			return NO;
			
		}
				
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return YES;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}		
	return NO;
}

- (BOOL)clearPractices{
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM t_practice where prac_id NOT IN (select my_prac_id from t_users where act_code <> '')"];
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete all from practices table on setup dao...");
			
			sqlite3_free(errorMsg);
			sqlite3_close(database);
			return NO;
			
		}
		
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return YES;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}		
	return NO;
}

- (BOOL)clearHospitals{
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM t_hospital where hos_id <> (select my_hos_id from t_users where act_code <> '')"];
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete all from hospital table on setup dao...");
			
			sqlite3_free(errorMsg);
			sqlite3_close(database);
			return NO;
			
		}
		
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return YES;
	}else {
		NSLog(@"Unable to open database connection on setup dao....");
	}		
	return NO;
}

@end
