//
//  DBManager.h
//  RealBox
//
//  Created by Thiruvengadam Krishnasamy on 26/08/13.
//  Copyright (c) 2013 TWILIGHT SOFTWARES. All rights reserved.
//

#import <sqlite3.h>
#import <Foundation/Foundation.h>

@interface DBManager : NSObject
{
     NSString *databasePath;

}
+(DBManager*)getSharedInstance;

-(NSMutableArray *)readInformationFromDatabase_tblReserve:(NSString*) tableName;
-(BOOL)functiontoImport_tblReserve:(NSMutableArray*) arrList;
-(void)DeleteAllDatafromLocalDB:(NSString*) tabl_Name;

@end
