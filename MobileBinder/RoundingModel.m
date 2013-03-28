#import "RoundingModel.h"
#import "Database.h"
#import "RoundingLog.h"
#import "SeniorRoundingDocumentGenerator.h"
#import "EmployeeRoundingLogManagedObject.h"

@interface RoundingModel()
@property (nonatomic, strong) UIManagedDocument *database;
@property (nonatomic, strong) NSMutableArray *roundingLogs;
@end

@implementation RoundingModel

- (RoundingLog *) addNewRoundingLog
{
    UIManagedDocument *database = [Database getInstance];
    EmployeeRoundingLogManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass(self.managedObjectClass) inManagedObjectContext:database.managedObjectContext];
    RoundingLog *log = [[self.roundingLogClass alloc] initWithManagedObject:managedObject];
    [self.roundingLogs addObject:log];
    return log;
}

- (void) deleteRoundingLog:(RoundingLog *)log
{
    [log deleteFromDatabase:[Database getInstance]];
    [self.roundingLogs removeObject:log];
}

- (NSArray *) getRoundingLogs
{
    return [self.roundingLogs copy];
}

- (void) fetchRoundingLogsForFutureUse
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Fetch notifications
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(self.managedObjectClass) inManagedObjectContext:self.database.managedObjectContext];
        
        NSArray *recordManagedObjects = [self.database.managedObjectContext executeFetchRequest: fetchRequest error: nil];
        self.roundingLogs = [[NSMutableArray alloc] init];
        for (EmployeeRoundingLogManagedObject *currentManagedObject in recordManagedObjects)
        {
            [self.roundingLogs addObject:[[self.roundingLogClass alloc] initWithManagedObject:currentManagedObject]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate doneRetrievingRoundingLogs];
        });
    });
}

- (MFMailComposeViewController *) generateRoundingDocumentFor: (RoundingLog *) log
{
   return [self.generator generateRoundingDocumentFor:log];
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
