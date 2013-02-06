#import <Foundation/Foundation.h>

@protocol DatabaseDelegate <NSObject>

- (void) obtainedDatabase: (UIManagedDocument *) database;

@end

@interface Database : NSObject

+ (UIManagedDocument *) getInstance;

+ (void) getDatabaseWithDelegate: (id<DatabaseDelegate>) delegate;

+ (void) saveDatabase;

@end
