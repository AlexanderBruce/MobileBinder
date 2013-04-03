#import "EmployeeRoundingModel.h"
#import "EmployeeRoundingLog.h"
#import "EmployeeRoundingLogManagedObject.h"
#import "EmployeeRoundingDocumentGenerator.h"

@implementation EmployeeRoundingModel

- (id) init
{
    if(self = [super init])
    {
        self.managedObjectClass = [EmployeeRoundingLogManagedObject class];
        self.roundingLogClass = [EmployeeRoundingLog class];
        self.generator = [[EmployeeRoundingDocumentGenerator alloc] init];
    }
    return self;
}

@end
