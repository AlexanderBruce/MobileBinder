#import <Foundation/Foundation.h>

@protocol DatabaseDelegate <NSObject>

- (void) obtainedDatabse: (UIManagedDocument *) database;

@end

@interface Database : NSObject

+ (void) getAttendanceDatabaseWithDelegate: (id<DatabaseDelegate>) delegate;

+ (void) saveAttendanceDatabase;

@end
