#import "SeniorRoundingModel.h"
#import "SeniorRoundingLog.h"
#import "SeniorRoundingDocumentGenerator.h"
#import "SeniorRoundingLogManagedObject.h"

@implementation SeniorRoundingModel

- (id) init
{
    if(self = [super init])
    {
        self.managedObjectClass = [SeniorRoundingLogManagedObject class];
        self.roundingLogClass = [SeniorRoundingLog class];
        self.generator = [[SeniorRoundingDocumentGenerator alloc] init];
    }
    return self;
}

@end
