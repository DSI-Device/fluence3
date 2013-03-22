//
//  registrationDao.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "registrationDao.h"


@implementation registrationDao



- (BOOL) activateUser: (NSMutableArray *)dataSource{
	
	NSDictionary *user = [dataSource objectAtIndex:0];
	NSDictionary *hosOrPrac = [dataSource objectAtIndex:1];
	NSDictionary *county = [dataSource objectAtIndex:2];
	NSDictionary *state = [dataSource objectAtIndex:3];
	
	NSInteger procId = 0;
	if (!([user objectForKey:@"my_practice_id"] == (id)[NSNull null] || [[user objectForKey:@"my_practice_id"] length] == 0)) {
			procId = [[user objectForKey:@"my_practice_id"] integerValue];
	}
	
	NSInteger hosId = 0;
	if (!([user objectForKey:@"my_hospital_id"] == (id)[NSNull null] || [[user objectForKey:@"my_hospital_id"] length] == 0)) {
		hosId = [[user objectForKey:@"my_hospital_id"] integerValue];
	}
	
	NSInteger cntyId = 0;
	if (!([county objectForKey:@"id"] == (id)[NSNull null] || [[county objectForKey:@"id"] length] == 0)) {
		cntyId = [[county objectForKey:@"id"] integerValue];
	}
	
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {

		char *errorMsg;
		
		NSString *deleteSQL = @"DELETE FROM t_users";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete from user table while registering...");
		}
		
		deleteSQL = @"DELETE FROM t_practice";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete from practice table while registering...");
		}
		
		deleteSQL = @"DELETE FROM t_hospital";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete from hospital table while registering...");
		}
		
		deleteSQL = @"DELETE FROM t_county";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete from county table while registering...");
		}
		
		NSString *insertSQL = [[NSString alloc] 
							   initWithFormat:@"INSERT OR REPLACE INTO t_users(user_id, last_name, first_name, email, act_code, my_prac_id, my_hos_id, my_county_id, need_to_sync, update_setting) VALUES (%d, \"%@\", \"%@\", \"%@\", \"%@\", %d, %d, %d, %d, %d);",
							   [[user objectForKey:@"id"] integerValue], [user objectForKey:@"last_name"], [user objectForKey:@"first_name"], [user objectForKey:@"email"], [user objectForKey:@"activation_code"], procId, hosId, cntyId, 1, 1];
		
		if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
			
			if(procId > 0){
				insertSQL = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE INTO t_practice( prac_id, name, address ) VALUES (%d, \"%@\", \"%@\");", 
							 [[hosOrPrac objectForKey:@"id"] integerValue], [hosOrPrac objectForKey:@"name"], [hosOrPrac objectForKey:@"add_line_1"]];
				
			}else if(hosId > 0){
				insertSQL = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE INTO t_hospital( hos_id, name, address ) VALUES (%d, \"%@\", \"%@\");", 
							 [[hosOrPrac objectForKey:@"id"] integerValue], [hosOrPrac objectForKey:@"name"], [hosOrPrac objectForKey:@"add_line_1"]];
			}
			
			if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				sqlite3_close(database);
				[insertSQL release];
				NSLog(@"Error updating t_practice/t_hospital while registering..");
				return NO;
			}
			
			// saving county
			insertSQL = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE INTO t_county( county_id, name, code, state_code ) VALUES (%d, \"%@\", \"%@\", \"%@\");", 
						 [[county objectForKey:@"id"] integerValue], [county objectForKey:@"name"], [county objectForKey:@"county_code"], [state objectForKey:@"state_code"]];
			
			if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				sqlite3_close(database);
				[insertSQL release];
				NSLog(@"Error updating t_county while registering..");
				return NO;
			}
			
		}else {
			//NSAssert1(0, @"Error updating t_user while registering: %s", errorMsg);
			NSLog(@"Error updating t_user while registering...%s",errorMsg);
			sqlite3_close(database);
			[insertSQL release];
			return NO;	
		}

		sqlite3_close(database);
		NSLog(@"user activation successfully done");
		[insertSQL release];
		
		return YES;
	}else {
		NSLog(@"Unable to open database connection for activation....");
		return NO;
	}

}

- (BOOL) updatePCPUserRegistration: (NSMutableArray *)dataSource{

	NSDictionary *user = [dataSource objectAtIndex:0];
	NSDictionary *practice = [dataSource objectAtIndex:1];

	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		
		NSString *deleteSQL = @"DELETE FROM t_users";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete from user table while pcp registering...");
		}
		
		deleteSQL = @"DELETE FROM t_practice";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete from practice table while pcp registering...");
		}
		
		NSString *insertSQL = [[NSString alloc] 
							   initWithFormat:@"INSERT OR REPLACE INTO t_users(user_id, last_name, first_name, email, act_code, my_prac_id, my_hos_id, my_county_id, need_to_sync, update_setting) VALUES (%d, \"%@\", \"%@\", \"%@\", \"%@\", %d, %d, %d, %d, %d);",
							   0, [user objectForKey:@"last_name"], [user objectForKey:@"first_name"], [user objectForKey:@"email"], @"", [[practice objectForKey:@"id"] integerValue], 0, 0, 1, 1];
		
		if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
			
			insertSQL = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE INTO t_practice( prac_id, name, address ) VALUES (%d, \"%@\", \"%@\");", 
						 [[practice objectForKey:@"id"] integerValue], [practice objectForKey:@"name"], [practice objectForKey:@"add_line1"]];

			if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				sqlite3_close(database);
				[insertSQL release];
				NSLog(@"Error updating t_practice while pcp registering..");
				return NO;
			}
			
		}else {
			//NSAssert1(0, @"Error updating t_user while registering: %s", errorMsg);
			NSLog(@"Error updating t_user while pcp registering....");
			sqlite3_close(database);
			[insertSQL release];
			return NO;	
		}	
		
		sqlite3_close(database);
		[insertSQL release];
		NSLog(@"pcp registration successfully done");
		return YES;
	}else {
		NSLog(@"Unable to open database connection for pcp registering....");
		return NO;
	}

}


- (BOOL) updateHospitalistRegistration: (NSMutableArray *)dataSource{
	
	NSDictionary *user = [dataSource objectAtIndex:0];
	NSDictionary *hospital = [dataSource objectAtIndex:1];
	
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		char *errorMsg;
		
		NSString *deleteSQL = @"DELETE FROM t_users";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete from user table while hospitalist registering...");
		}
		
		deleteSQL = @"DELETE FROM t_hospital";
		if(sqlite3_exec(database, [deleteSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to delete from hospital table while hospitalist registering...");
		}
		
		NSString *insertSQL = [[NSString alloc] 
							   initWithFormat:@"INSERT OR REPLACE INTO t_users(user_id, last_name, first_name, email, act_code, my_prac_id, my_hos_id, my_county_id, need_to_sync, update_setting) VALUES (%d, \"%@\", \"%@\", \"%@\", \"%@\", %d, %d, %d, %d, %d);",
							   0, [user objectForKey:@"last_name"], [user objectForKey:@"first_name"], [user objectForKey:@"email"], @"", 0, [[hospital objectForKey:@"id"] integerValue], 0, 1, 1];
		
		if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
			
			insertSQL = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE INTO t_hospital( hos_id, name, address ) VALUES (%d, \"%@\", \"%@\");", 
						 [[hospital objectForKey:@"id"] integerValue], [hospital objectForKey:@"name"], [hospital objectForKey:@"add_line1"]];
			
			if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				sqlite3_close(database);
				[insertSQL release];
				NSLog(@"Error updating t_hospital while hospitalist registering..");
				return NO;
			}
			
		}else {
			//NSAssert1(0, @"Error updating t_user while registering: %s", errorMsg);
			NSLog(@"Error updating t_user while hospitalist registering....");
			sqlite3_close(database);
			[insertSQL release];
			return NO;	
		}	
		
		sqlite3_close(database);
		[insertSQL release];
		NSLog(@"hospitalist registration successfully done");
		return YES;
	}else {
		NSLog(@"Unable to open database connection for hospitalist registering....");
		return NO;
	}
	
}

- (NSDictionary *) getRegisteredUser{

	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSString *query = @"SELECT last_name, first_name, email, my_prac_id, my_hos_id from t_users where act_code = ''";
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			if(sqlite3_step(statement) == SQLITE_ROW) {
				
				NSString *pracName = nil;
				NSString *pracAddr = nil;

				NSString *lastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				NSString *firstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				NSString *email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				int pracId = sqlite3_column_int(statement, 3);
				int hosId = sqlite3_column_int(statement, 4);
				
				sqlite3_finalize(statement);

				if (pracId > 0) {
					query = @"SELECT name, address from t_practice where prac_id =  ?";
					sqlite3_stmt *stmt;

					if(sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK){
						sqlite3_bind_int(stmt, 1, pracId);
						
						if(sqlite3_step(stmt) == SQLITE_ROW) {
							
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
				
				sqlite3_close(database);
				
				return [[NSDictionary alloc] initWithObjectsAndKeys: lastName, @"last_name", firstName, @"first_name", email, @"email", pracName, @"prac_name", pracAddr, @"prac_addr", nil];

			}
			
		}else {
			NSLog(@"error on select query [isUserAlreadyRegistered]");
		}
				
		sqlite3_close(database);
		NSLog(@"irefer DDL successfully done[isUserAlreadyRegistered] on sqlite3");
	}
	
	return nil;
}

@end
