#import <Foundation/Foundation.h>

@protocol DatabaseDelegate <NSObject>

- (void) obtainedDatabase: (UIManagedDocument *) database;

@end

@interface Database : NSObject

//REFACTOR THIS AT SOME POINT

+ (UIManagedDocument *) getInstance;

+ (void) getDatabaseWithDelegate: (id<DatabaseDelegate>) delegate;

+ (void) saveDatabase;

+ (void) saveDatabaseWithCompletion: (void (^) (void)) block;

@end
