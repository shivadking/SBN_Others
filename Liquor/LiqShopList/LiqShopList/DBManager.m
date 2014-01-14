//
//  DBManager.m
//  RealBox
//
//  Created by Thiruvengadam Krishnasamy on 26/08/13.
//  Copyright (c) 2013 TWILIGHT SOFTWARES. All rights reserved.
//
#import <sqlite3.h>
#import "DBManager.h"


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
    NSString *appDBPath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"dbLiquors.sqlite"]];
    
    NSLog(@"DBpath ====> %@",appDBPath);
    
    success = [fileManager fileExistsAtPath:appDBPath];
    if (success)
    {
        return;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dbLiquors.sqlite"];
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
    
    databasePath = [documentPath stringByAppendingPathComponent:@"dbLiquors.sqlite"];
    
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
                
            NSString *PickupAddr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
            NSString *DestAddr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
            NSString *Name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            NSString *Phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            NSString *Email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            NSString *updatedDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
                    
                [_dataDictionary setObject:[NSString stringWithFormat:@"%@",PickupAddr] forKey:@"PickupAddr"];
                [_dataDictionary setObject:[NSString stringWithFormat:@"%@",DestAddr] forKey:@"DestAddr"];
                [_dataDictionary setObject:[NSString stringWithFormat:@"%@",Name] forKey:@"Name"];
                [_dataDictionary setObject:[NSString stringWithFormat:@"%@",Phone] forKey:@"Phone"];
                [_dataDictionary setObject:[NSString stringWithFormat:@"%@",Email] forKey:@"Email"];
                [_dataDictionary setObject:[NSString stringWithFormat:@"%@",updatedDate] forKey:@"updatedDate"];

                
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
    databasePath = [documentPath stringByAppendingPathComponent:@"dbLiquors.sqlite"];
  
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
       
        /*NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        NSDate *now = [NSDate date];
        NSString *dateTime  = [dateFormat stringFromDate:now];*/
       
        statements = @"insert into tblReserve(PickupAddr,DestAddr,Name,Phone,Email,updatedDate) values(?,?,?,?,?,?)";
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [statements UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            for(int i = 0; i < [arrList count]; i++)
            {
                NSMutableDictionary *dic = [arrList objectAtIndex:i];
                
                NSLog(@"Dic Data ==> %@",dic);
                               
                NSString *PickupAddr = [dic objectForKey:@"PickupAddr"];
                NSString *DestAddr = [dic objectForKey:@"DestAddr"];
                NSString *Name = [dic objectForKey:@"Name"];
                NSString *Phone = [dic objectForKey:@"Phone"];
                NSString *Email = [dic objectForKey:@"Email"];
                NSString *updatedDate = [dic objectForKey:@"updatedDate"];
                
                sqlite3_bind_text(compiledStatement, 1, [PickupAddr UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 2, [DestAddr UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 3, [Name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 4, [Phone UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 5, [Email UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 6, [updatedDate UTF8String], -1, SQLITE_TRANSIENT);
  
                
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
    databasePath = [documentPath stringByAppendingPathComponent:@"dbLiquors.sqlite"];
    
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
