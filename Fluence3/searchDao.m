//
//  searchDao.m
//  irefer2
//
//  Created by Mushraful Hoque on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "searchDao.h"


@implementation searchDao

- (NSMutableArray *) getDoctorList:(NSString *)docName insIds:(NSString *)insIds hosIds:(NSString *)hosIds spIds:(NSString *)spIds pracIds:(NSString *)pracIds countyIds:(NSString *)countyIds languages:(NSString *)languages officeHours:(NSString *)officeHours zip:(NSString *)zipCode inPatient:(NSString *)inPatient order:(int)order limit:(int)limit{
	
	limit++;//sqlite3 exclude the upper bound so increasing one to get the exact result
	if(docName == nil || [docName isEqual:@""])
		docName = @"%";
	else 
		docName = [[@"%" stringByAppendingString:docName] stringByAppendingString:@"%"];
	
	
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];	
	
		NSString *additionalPrac = @"";
		NSString *whereClause = [NSString stringWithFormat:@"WHERE (doc.first_name like \"%@\" OR doc.mid_name like \"%@\" OR doc.last_name like \"%@\")", docName, docName, docName];
		
		if (![insIds isEqual:@""]) {
			whereClause = [whereClause stringByAppendingFormat:@" AND doc.ins_id in (%@)",insIds];
		}	
		if (![hosIds isEqual:@""]) {
			whereClause = [whereClause stringByAppendingFormat:@" AND doc.hos_id in (%@)",hosIds];
		}	
		if (![spIds isEqual:@""]) {
			whereClause = [whereClause stringByAppendingFormat:@" AND doc.spec_id in (%@)",spIds];
		}
		if (![pracIds isEqual:@""]) {
			whereClause = [whereClause stringByAppendingFormat:@" AND doc.prac_id in (%@)",pracIds];
			additionalPrac = [NSString stringWithFormat:@" AND tp.prac_id in (%@)",pracIds];
		}
		if (![countyIds isEqual:@""]) {
			whereClause = [whereClause stringByAppendingFormat:@" AND doc.county_id in (%@)",countyIds];
		}
		if (![zipCode isEqual:@""]) {
			whereClause = [whereClause stringByAppendingFormat:@" AND doc.zip_code = %@",zipCode];
		}	
		if ([inPatient isEqual:@"1"]) {
			whereClause = [whereClause stringByAppendingString:@" AND doc.see_patient = 1"];
		}	
		
		if (languages != nil && ![languages isEqual:@""]) {
			
			NSArray *tokens = [languages componentsSeparatedByString:@","];
			for( NSString *lang in tokens ){
				whereClause = [whereClause stringByAppendingFormat:@" AND doc.language LIKE \"%@\"",[[@"%" stringByAppendingString:lang] stringByAppendingString:@"%"]];
			}
		}
		
		if (officeHours != nil && ![officeHours isEqual:@""]) {
			
			NSArray *tokens = [officeHours componentsSeparatedByString:@","];
			NSString *officeQuery = @"";

			for( NSString *oHrs in tokens ){
				if ([officeQuery isEqual:@""]) {
					officeQuery = [officeQuery stringByAppendingFormat:@"doc.office_hour LIKE \"%@\"",[[@"%" stringByAppendingString:oHrs] stringByAppendingString:@"%"]];
				}else {
					officeQuery = [officeQuery stringByAppendingFormat:@" OR doc.office_hour LIKE \"%@\"",[[@"%" stringByAppendingString:oHrs] stringByAppendingString:@"%"]];
				}

			}
			if( ![officeQuery isEqual:@""] ){
				whereClause = [whereClause stringByAppendingFormat:@" AND ( %@ )",officeQuery];
			}
		}
		
		NSString *query = [NSString stringWithFormat:@"SELECT distinct doc.doc_id, doc.first_name, doc.last_name, doc.mid_name, doc.degree, doc.language, doc.grade, doc.doc_phone, doc.u_rank, IFNULL(prac.name, '') as name FROM t_doctor doc LEFT JOIN (SELECT distinct t1.doc_id, GROUP_CONCAT(tp.name,',') name1, tp.name from t_doctor t1 JOIN t_practice tp ON(t1.prac_id = tp.prac_id%@) group by t1.doc_id) prac ON (doc.doc_id = prac.doc_id) %@",  additionalPrac, whereClause];
		
		NSString *countQuery = [NSString stringWithFormat:@"SELECT count(distinct(doc.doc_id)) FROM t_doctor doc %@", whereClause];
		
		if (order == 0) {
			query = [query stringByAppendingFormat:@" order by doc.u_rank desc, doc.grade desc, doc.last_name"];
		}else if (order == 1) {
			query = [query stringByAppendingFormat:@" order by doc.grade desc, doc.u_rank desc, doc.last_name"];
		}else if (order == 2) {
			query = [query stringByAppendingFormat:@" order by doc.first_name, doc.u_rank desc, doc.grade desc"];
		}else if (order == 3) {
			query = [query stringByAppendingFormat:@" order by doc.last_name, doc.u_rank desc, doc.grade desc"];
		}else {
			query = [query stringByAppendingFormat:@" order by doc.u_rank desc, doc.grade desc, doc.last_name"];
		}
		
		query = [query stringByAppendingFormat:@" limit %d",limit];
		NSLog(@"query : %@",query);
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [countQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
			if (sqlite3_step(statement) == SQLITE_ROW) {
				[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithUTF8String: sqlite3_column_text(statement, 0)],@"count",nil] autorelease]];
			}
		}
		
		sqlite3_finalize(statement);
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			while(sqlite3_step(statement) == SQLITE_ROW) {
			
				[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithUTF8String: sqlite3_column_text(statement, 0)], @"id", 
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 1)], @"first_name", 
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 2)], @"last_name",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 3)], @"mid_name",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 4)], @"degree",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 5)], @"language",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 6)], @"grade",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 7)], @"doc_phone",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 8)], @"u_rank",
								   
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 9)], @"prac_name", nil] autorelease]];
			}
			
		}else {
			NSLog(@"error on select query [getDoctorList] on search dao");
			sqlite3_finalize(statement);	
			sqlite3_close(database);
			return nil;
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		return array;
		
	}else {
		NSLog(@"unable to open database ");
		
	}

	return nil;
}


- (NSMutableDictionary *) getDoctorDetails:(NSString *)docId{
	
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		NSLog(@"before the query......");

		NSString *query = [NSString stringWithString:@"SELECT doc.doc_id, doc.first_name, doc.mid_name, doc.last_name, doc.degree, "];
		query = [query stringByAppendingFormat:@"doc.doc_phone, doc.language, doc.grade, doc.gender, doc.image_url, doc.npi, doc.doc_fax, doc.office_hour, "];		   
		query = [query stringByAppendingFormat:@"IFNULL(hos.see_patient, '0'), doc.u_rank, pa.up_rank, hos.name, ins.name, sp.name, cnt.name, pa.name, pa.address,  doc.quality, doc.cost, doc.rank_user_number, IFNULL(doc.avg_rank, '0') "];		   
		query = [query stringByAppendingFormat:@"from t_doctor doc LEFT JOIN (SELECT distinct dh.doc_id, GROUP_CONCAT(th.name,'|') name, GROUP_CONCAT(dh.see_patient,'|') see_patient from t_hospital th, (select distinct t1.hos_id, t1.doc_id, t1.see_patient from t_doctor t1 where t1.doc_id = %@)dh WHERE dh.hos_id = th.hos_id) hos ON (doc.doc_id = hos.doc_id) ",docId];		   
		query = [query stringByAppendingFormat:@"LEFT JOIN (SELECT distinct di.doc_id, GROUP_CONCAT(ti.name,',') name from t_insurance ti, (select distinct t1.ins_id, t1.doc_id from t_doctor t1 where t1.doc_id = %@)di WHERE di.ins_id = ti.ins_id) ins ON (doc.doc_id = ins.doc_id) ", docId];		   
		query = [query stringByAppendingFormat:@"LEFT JOIN (SELECT distinct ds.doc_id, GROUP_CONCAT(ts.name,',') name from t_speciality ts, (select distinct t1.spec_id, t1.doc_id from t_doctor t1 where t1.doc_id = %@)ds WHERE ds.spec_id = ts.spec_id) sp ON (doc.doc_id = sp.doc_id) ", docId];		   
		query = [query stringByAppendingFormat:@"LEFT JOIN t_county cnt ON (doc.county_id = cnt.county_id) "];		   
		query = [query stringByAppendingFormat:@"LEFT JOIN (SELECT distinct dp.doc_id, GROUP_CONCAT(tp.name,'|') name, GROUP_CONCAT(tp.address,'|') address, GROUP_CONCAT(dp.up_rank, '|') up_rank from t_practice tp, (select distinct t1.prac_id, t1.doc_id, t1.up_rank from t_doctor t1 where t1.doc_id = %@)dp WHERE dp.prac_id = tp.prac_id) pa ON (doc.doc_id = pa.doc_id) where doc.doc_id = %@", docId, docId];		   
/*		
		query = [query stringByAppendingFormat:@"LEFT JOIN (SELECT distinct dp.doc_id, GROUP_CONCAT(tp.name,'|') name, 
				 GROUP_CONCAT(tp.address,'|') address, GROUP_CONCAT(dp.up_rank, '|') up_rank from t_practice tp, 
				 (select distinct t1.prac_id, t1.doc_id, t1.up_rank from t_doctor t1 where t1.doc_id = %@)dp WHERE dp.prac_id = tp.prac_id) pa 
				 ON (doc.doc_id = pa.doc_id) where doc.doc_id = %@", docId, docId];		   
*/		
		NSLog(@"query : %@",query);
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			if(sqlite3_step(statement) == SQLITE_ROW) {
				NSLog(@"after the query......");
				
				NSString *hospName = @"";
				if (sqlite3_column_text(statement, 16) != NULL) {
					hospName = [NSString stringWithUTF8String: sqlite3_column_text(statement, 16)];
				}
				
				NSString *insName = @"";
				if (sqlite3_column_text(statement, 17) != NULL) {
					insName = [NSString stringWithUTF8String: sqlite3_column_text(statement, 17)];
				}
				
				NSString *specName = @"";
				if (sqlite3_column_text(statement, 18) != NULL) {
					specName = [NSString stringWithUTF8String: sqlite3_column_text(statement, 18)];
				}
				
				NSString *countyName = @"";
				if (sqlite3_column_text(statement, 19) != NULL) {
					countyName = [NSString stringWithUTF8String: sqlite3_column_text(statement, 19)];
				}
				
				NSString *pracName = @"";
				if (sqlite3_column_text(statement, 20) != NULL) {
					pracName = [NSString stringWithUTF8String: sqlite3_column_text(statement, 20)];
				}
				
				NSString *pracAddr = @"";
				if (sqlite3_column_text(statement, 21) != NULL) {
					pracAddr = [NSString stringWithUTF8String: sqlite3_column_text(statement, 21)];
				}
				NSLog(@"before the query.....2222222.");

				NSMutableDictionary *dataSet = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSString stringWithUTF8String: sqlite3_column_text(statement, 0)], @"id", 
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 1)], @"first_name", 
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 2)], @"mid_name",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 3)], @"last_name",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 4)], @"degree",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 5)], @"doc_phone",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 6)], @"language",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 7)], @"grade",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 8)], @"gender",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 9)], @"image_url",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 10)], @"npi",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 11)], @"doc_fax",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 12)], @"office_hour",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 13)], @"see_patient",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 14)], @"u_rank",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 15)], @"up_rank",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 22)], @"quality",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 23)], @"cost",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 24)], @"rank_user_number",
										 [NSString stringWithUTF8String: sqlite3_column_text(statement, 25)], @"avg_rank",		
										 hospName, @"hosp_name",
										 insName, @"insu_name",
										 specName, @"spec_name",
										 countyName, @"county",
										 pracName, @"prac_name",
										 pracAddr, @"add_line_1",@"",@"note",nil];

				
				sqlite3_finalize(statement);	
				sqlite3_close(database);
				return dataSet;		
				
			}else {
				NSLog(@"error on select query [getDoctorDetail]1 on search dao");
			}
			
		}else {
			NSLog(@"error on select query [getDoctorDetail] on search dao");
		}
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		return nil;
		
		
	}else {
		NSLog(@"unable to open database ");
		
	}	
	return nil;
}

- (NSMutableArray *) getAdvDoctorList:(NSString *)searchCode order:(int)order limit:(int)limit{
	if(searchCode == nil)
		searchCode = @"";

	NSMutableArray *tokens = [[NSMutableArray alloc] init];
	NSArray *codes = [searchCode componentsSeparatedByString:@" "];
	for( NSString *code in codes){
		if(code != nil && ![code isEqual:@""])
			[tokens addObject:[[@"%" stringByAppendingString:code] stringByAppendingString:@"%"]];
	}
		
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];	
		
		NSString *query = [NSString stringWithFormat:@"%@ %@ %@ %@",
						   @"SELECT distinct doc.doc_id, doc.first_name, doc.last_name, doc.mid_name, doc.degree, doc.language, doc.grade, doc.doc_phone, doc.u_rank, IFNULL(prac1.name, '') as name",
						   @"FROM t_doctor doc LEFT JOIN (SELECT distinct t1.doc_id, GROUP_CONCAT(tp.name,',') name1, tp.name from t_doctor t1 JOIN t_practice tp ON(t1.prac_id = tp.prac_id) group by t1.doc_id) prac1 ON (doc.doc_id = prac1.doc_id)",
						   @"LEFT JOIN t_practice prac ON (doc.prac_id = prac.prac_id) LEFT JOIN t_hospital hos ON (doc.hos_id = hos.hos_id) LEFT JOIN t_speciality spec ON (doc.spec_id = spec.spec_id) LEFT JOIN t_insurance ins ON (doc.ins_id = ins.ins_id)",
						   @"LEFT JOIN t_county county ON (doc.county_id = county.county_id) "];

		NSString *countQuery = [NSString stringWithFormat:@"%@ %@ %@ %@",
						   @"SELECT count(distinct(doc.doc_id)) ",
						   @"FROM t_doctor doc LEFT JOIN t_practice prac ON (doc.prac_id = prac.prac_id) LEFT JOIN t_hospital hos ON (doc.hos_id = hos.hos_id)",
						   @"LEFT JOIN t_speciality spec ON (doc.spec_id = spec.spec_id) LEFT JOIN t_insurance ins ON (doc.ins_id = ins.ins_id)",
						   @"LEFT JOIN t_county county ON (doc.county_id = county.county_id) "];
		
		NSString *subQuery;
		BOOL isFirst = YES;				   
		for( NSString *token in tokens ){
			subQuery = @"";
			
			subQuery = [subQuery stringByAppendingFormat:@"doc.first_name LIKE \"%@\"",token];			
			subQuery = [subQuery stringByAppendingFormat:@" OR doc.mid_name LIKE \"%@\"",token];
			subQuery = [subQuery stringByAppendingFormat:@" OR doc.last_name LIKE \"%@\"",token];
			subQuery = [subQuery stringByAppendingFormat:@" OR doc.degree LIKE \"%@\"",token];
			subQuery = [subQuery stringByAppendingFormat:@" OR doc.language LIKE \"%@\"",token];
			subQuery = [subQuery stringByAppendingFormat:@" OR doc.grade LIKE \"%@\"",token];
			subQuery = [subQuery stringByAppendingFormat:@" OR doc.doc_phone LIKE \"%@\"",token];
			subQuery = [subQuery stringByAppendingFormat:@" OR doc.doc_fax LIKE \"%@\"",token];
			subQuery = [subQuery stringByAppendingFormat:@" OR doc.npi LIKE \"%@\"",token];
			subQuery = [subQuery stringByAppendingFormat:@" OR doc.office_hour LIKE \"%@\"",token];			
			subQuery = [subQuery stringByAppendingFormat:@" OR prac.name LIKE \"%@\"",token];			
			subQuery = [subQuery stringByAppendingFormat:@" OR prac.address LIKE \"%@\"",token];			
			subQuery = [subQuery stringByAppendingFormat:@" OR hos.name LIKE \"%@\"",token];			
			subQuery = [subQuery stringByAppendingFormat:@" OR spec.name LIKE \"%@\"",token];			
			subQuery = [subQuery stringByAppendingFormat:@" OR ins.name LIKE \"%@\"",token];			
			subQuery = [subQuery stringByAppendingFormat:@" OR county.name LIKE \"%@\"",token];			
			
			if (isFirst) {
				isFirst = NO;
				query = [query stringByAppendingFormat:@"WHERE (%@) ",subQuery];
				countQuery = [countQuery stringByAppendingFormat:@"WHERE (%@) ",subQuery];

			}else {
				query = [query stringByAppendingFormat:@"AND (%@) ",subQuery];
				countQuery = [countQuery stringByAppendingFormat:@"AND (%@) ",subQuery];
				
			}

		}
		
		if (order == 0) {
			query = [query stringByAppendingFormat:@" order by doc.u_rank desc, doc.grade desc, doc.last_name"];
		}else if (order == 1) {
			query = [query stringByAppendingFormat:@" order by doc.grade desc, doc.u_rank desc, doc.last_name"];
		}else if (order == 2) {
			query = [query stringByAppendingFormat:@" order by doc.first_name, doc.u_rank desc, doc.grade desc"];
		}else if (order == 3) {
			query = [query stringByAppendingFormat:@" order by doc.last_name, doc.u_rank desc, doc.grade desc"];
		}else {
			query = [query stringByAppendingFormat:@" order by doc.u_rank desc, doc.grade desc, doc.last_name"];
		}
						
		query = [query stringByAppendingFormat:@" limit %d",limit];

		[tokens release];
		NSLog(@"query : %@",query);
		sqlite3_stmt *statement;
		
		
		if(sqlite3_prepare_v2(database, [countQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
			if (sqlite3_step(statement) == SQLITE_ROW) {
				[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithUTF8String: sqlite3_column_text(statement, 0)],@"count",nil] autorelease]];
			}
		}
		
		sqlite3_finalize(statement);
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithUTF8String: sqlite3_column_text(statement, 0)], @"id", 
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 1)], @"first_name", 
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 2)], @"last_name",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 3)], @"mid_name",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 4)], @"degree",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 5)], @"language",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 6)], @"grade",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 7)], @"doc_phone",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 8)], @"u_rank",
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 9)], @"prac_name", nil] autorelease]];
			}
			
		}else {
			NSLog(@"error on select query [getDoctorList] on search dao");
			sqlite3_finalize(statement);	
			sqlite3_close(database);
			return nil;
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		return array;
		
	}else {
		NSLog(@"unable to open database ");
		
	}
	
	return nil;
	
}

- (BOOL) updateDoctorRank:(int)docId rank:(int)rankValue{

	NSDictionary *rankInfo = [self getDoctorRankInfo:docId];

	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		float newAvgRank = rankValue;
		int rankUserNumber = [[rankInfo valueForKey:@"rankUserNumber"] intValue];

		if (rankUserNumber > 0) {
			int prevRank = [[rankInfo valueForKey:@"rank"] intValue];
			
			
			if (prevRank == 0) {
				rankUserNumber++;
			}
			newAvgRank = (([[rankInfo valueForKey:@"avgRank"] floatValue] * rankUserNumber) - prevRank + rankValue)/rankUserNumber; 
			
		}else {
			rankUserNumber = 1;
		}

		
		char *errorMsg;
		NSString *insertSQL = [[NSString alloc] 
							   initWithFormat:@"UPDATE t_doctor SET u_rank=%d, rank_user_number=%d, avg_rank=%f, rank_update=1 WHERE doc_id=%d", rankValue, rankUserNumber, newAvgRank, docId];
		
		if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
			
			sqlite3_close(database);
			[insertSQL release];
			NSLog(@"successfully updated doctor rank..");
			return YES;
			
		}else {
			sqlite3_close(database);
			[insertSQL release];
			NSLog(@"Error updating doctor rank..");
			return NO;			
		}
			
		
	}else {
		NSLog(@"Unable to open database connection for rank update....");
	}
	
	return NO;
}

- (NSDictionary *)getDoctorRankInfo:(int)docId{
	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		
		NSUInteger *rank;
		NSUInteger *rankUserNumber;
		NSString *avgRank;
		
		NSString *query = [NSString stringWithFormat: @"SELECT u_rank, rank_user_number, avg_rank from t_doctor WHERE doc_id=%d",docId];
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			if(sqlite3_step(statement) == SQLITE_ROW) {
				
				rank = sqlite3_column_int(statement, 0);
				rankUserNumber = sqlite3_column_int(statement, 1);
	
				avgRank = [NSString stringWithUTF8String: sqlite3_column_text(statement, 2)];
			}else {
				NSLog(@"error on select query [getDoctorRankInfo] on search dao");
			}
		}else {
			NSLog(@"error on select query [getDoctorRankInfo] on search dao");
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
	
		return [[[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithFormat:@"%d", rank], @"rank", 
				[NSString stringWithFormat:@"%d", rankUserNumber], @"rankUserNumber",avgRank, @"avgRank", nil] autorelease];
	}else {
		NSLog(@"Unable to open database connection on search dao....");
	}
	return NULL;	
}


- (NSArray *) getReportListByDoctor:(NSString *)docId{

	if (sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK) {
		NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];	

		NSString *query = [NSString stringWithFormat:@"SELECT description, report_time FROM t_doc_report WHERE doc_id = %@", docId];
		
		NSLog(@"query : %@",query);
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			
			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				[array addObject:[[[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithUTF8String: sqlite3_column_text(statement, 0)], @"text", 
								   [NSString stringWithUTF8String: sqlite3_column_text(statement, 1)], @"rtime", nil] autorelease]];
			}
			
		}else {
			NSLog(@"error on select query [getReportList] on search dao");
			sqlite3_finalize(statement);	
			sqlite3_close(database);
			return nil;
		}
		
		sqlite3_finalize(statement);	
		sqlite3_close(database);
		return array;		
		
	}else {
		NSLog(@"Unable to open database connection for report list....");
	}
	
	return nil;	
}

- (BOOL) updateDoctorChangeReport:(NSString *)docId userId:(NSString *)userId content:(NSString *)msg{
	
	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {
		NSLog(@"doc: %@ user: %@ content: %@", docId, userId, msg);
		char *errorMsg;
		NSString *insertSQL = [[NSString alloc] 
							   initWithFormat:@"INSERT OR REPLACE INTO t_doc_report(doc_id, user_id, description, report_time, submit_time) VALUES (%@, %@, \"%@\", \"%@\", '')",
							   docId, userId, msg, [utils getFormatedStringFromDate:[NSDate date]] ];
		
		if (sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
			
			sqlite3_close(database);
			[insertSQL release];
			NSLog(@"successfully updated doctor change report..");
			return YES;
			
		}else {
			sqlite3_close(database);
			[insertSQL release];
			NSLog(@"Error updating doctor change report..%s",errorMsg);
			return NO;			
		}
		
		
	}else {
		NSLog(@"Unable to open database connection for doc change report....");
	}
	
	return NO;
}

- (void) updateSearchCount:(int)type{

	if (sqlite3_open([[super dataFilePath] UTF8String], &database) == SQLITE_OK) {

		
		NSString *query = [NSString stringWithFormat:@"SELECT count from t_statistics where count_type=%d",type];
		sqlite3_stmt *statement;
		
		int count = 0;
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			if(sqlite3_step(statement) == SQLITE_ROW) {
				
				count = sqlite3_column_int(statement, 0);
							
			}
		}else {
			NSLog(@"error on select query [updateSearchCount]");
		}
		sqlite3_finalize(statement);		
		NSLog(@"search count %d",count);
		char *errorMsg;
		NSString *updateSQL = @"";
		if (count == 0) {
			updateSQL = [NSString stringWithFormat:@"insert or replace into t_statistics(count_type, count) values(%d, %d);", type, count+1];

		}else {
			updateSQL = [NSString stringWithFormat:@"update t_statistics set count=count+1 where count_type=%d;", type];
			
		}

		if(sqlite3_exec(database, [updateSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
			NSLog(@"unable to update user statistics on search dao...");
		}
		
		
		sqlite3_free(errorMsg);
		sqlite3_close(database);
		return;		
		
	}else {
		NSLog(@"Unable to open database connection for user statistics....");
	}

}

@end
