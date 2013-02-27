#import "RoundingModel.h"
#import "Database.h"
#import "RoundingLog.h"
#import "RoundingLogManagedObject.h"

@interface RoundingModel()
@property (nonatomic, strong) UIManagedDocument *database;
@property (nonatomic, strong) NSMutableArray *roundingLogs;
@end

@implementation RoundingModel

- (NSArray *) getRoundingLogs
{
    return [self.roundingLogs copy];
}

- (void) fetchRoundingLogsForFutureUse
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Fetch notifications
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([RoundingLogManagedObject class]) inManagedObjectContext:self.database.managedObjectContext];
        
        NSArray *recordManagedObjects = [self.database.managedObjectContext executeFetchRequest: fetchRequest error: nil];
        self.roundingLogs = [[NSMutableArray alloc] init];
        for (RoundingLogManagedObject *currentManagedObject in recordManagedObjects)
        {
            [self.roundingLogs addObject:[[RoundingLog alloc] initWithManagedObject:currentManagedObject]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate doneRetrievingRoundingLogs];
        });
    });
}


- (id) init
{
    if(self = [super init])
    {
        self.database = [Database getInstance];
    }
    return self;
}
@end
