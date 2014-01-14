//
//  DBManager.m
//  LiquorsList
//
//  Created by Thiruvengadam Krishnasamy on 16/12/13.
//  Copyright (c) 2013 TWILIGHT SOFTWARES. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

static DBManager *sharedInstance = nil;
//static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;



@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createCopyOfDatabaseIfNeeded];
    }
    return sharedInstance;
}

- (void)createCopyOfDatabaseIfNeeded
{
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Database filename can have extension db/sqlite.
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appDBPath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"dbLiquors.db"]];
    
    NSLog(@"DBpath ====> %@",appDBPath);
    
    success = [fileManager fileExistsAtPath:appDBPath];
    if (success)
    {
        return;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dbLiquors.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:appDBPath error:&error];
    if (!success)
    {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
}

#pragma mark - Retrieve Data from LocalDB

-(NSMutableArray *)readInformationFromDatabase_tblReserve:(NSString*) tableName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentPath = [paths objectAtIndex:0];
    
    databasePath = [documentPath stringByAppendingPathComponent:@"dbLiquors.db"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // Setup the database object
    sqlite3 *database;
    
    // Open the database from the users filessytem
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        
        
        NSString *str = [@"Select * from " stringByAppendingString:tableName];
        NSString *sqlStatement_userInfo =str;  //@"Select Date,AK from tbl_IndexValue"];
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                // Init the Data Dictionary
                NSMutableDictionary *_dataDictionary=[[NSMutableDictionary alloc] init];
                
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
                NSString *address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
                NSString *phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
               
                
                [_dataDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"name"];
                [_dataDictionary setObject:[NSString stringWithFormat:@"%@",address] forKey:@"address"];
                [_dataDictionary setObject:[NSString stringWithFormat:@"%@",phone] forKey:@"phone"];
                [array addObject:_dataDictionary];
                NSLog(@"Retrieved Data From DB==>%@",array);
                }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(database);
    
    return array;
}
#pragma mark - Import data into LocalDB

-(BOOL)functiontoImport_tblReserve:(NSMutableArray*) arrList
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    databasePath = [documentPath stringByAppendingPathComponent:@"dbLiquors.db"];
    
    sqlite3 *database;
    
    // Open the database from the users filessytem
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSString* statements;
        
        statements = @"BEGIN EXCLUSIVE TRANSACTION";
        
        if (sqlite3_prepare_v2(database, [statements UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            printf("db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            sqlite3_finalize(statement);
            printf("db error: %s\n", sqlite3_errmsg(database));
            return NO;
        }
        
        NSTimeInterval timestampB = [[NSDate date] timeIntervalSince1970];
        
        statements = @"insert into tblLiquorsShopList(name,address,phone) values(?,?,?)";
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [statements UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            for(int i = 0; i < [arrList count]; i++)
            {
                NSMutableDictionary *dic = [arrList objectAtIndex:i];
                
                NSLog(@"Dic Data ==> %@",dic);
                
                NSString *name = [dic objectForKey:@"name"];
                NSString *address = [dic objectForKey:@"address"];
                NSString *phone = [dic objectForKey:@"phone"];
               
                
                sqlite3_bind_text(compiledStatement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 2, [address UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 3, [phone UTF8String], -1, SQLITE_TRANSIENT);
               
                
                
                while(YES){
                    NSInteger result = sqlite3_step(compiledStatement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY){
                        printf("db error: %s\n", sqlite3_errmsg(database));
                        break;
                    }
                }
                sqlite3_reset(compiledStatement);
                
            }
            timestampB = [[NSDate date] timeIntervalSince1970] - timestampB;
            NSLog(@"Insert Time Taken: %f",timestampB);
            
            // COMMIT
            statements = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(database, [statements UTF8String], -1, &commitStatement, NULL) != SQLITE_OK)
            {
                printf("db error: %s\n", sqlite3_errmsg(database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE)
            {
                printf("db error: %s\n", sqlite3_errmsg(database));
                return NO;
            }
            
            //     sqlite3_finalize(beginStatement);
            sqlite3_finalize(compiledStatement);
            sqlite3_finalize(commitStatement);
            sqlite3_close(database);
            NSLog(@"Closed at tblReserve");
            return YES;
        }
    }
    
    return YES;
    
}
#pragma mark - Deleting Records from LocaDB
-(void)DeleteAllDatafromLocalDB:(NSString*) tabl_Name

{
    NSString *ns_sql = [NSString stringWithFormat:@"DELETE FROM %@",tabl_Name];
    const char *sql = [ns_sql cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *statement = nil;
    
    //sqlite3* db = ...; //get the database instance
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    databasePath = [documentPath stringByAppendingPathComponent:@"dbLiquors.db"];
    
    sqlite3 *database;
    
    // Open the database from the users filessytem
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        
        
        if(sqlite3_prepare_v2(database, sql, -1, &statement, nil) != SQLITE_OK) {
            return;
        }
        
        //Without this line, table is not modified
        int code = sqlite3_step(statement);
        
        if (code == SQLITE_ROW) {
            //Do nothing here...
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(database);
        NSLog(@"Closed at DB Delete");
    }
    
}






@end
