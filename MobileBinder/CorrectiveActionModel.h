#import <Foundation/Foundation.h>
@class EmployeeRecord;

@interface CorrectiveActionModel : NSObject

typedef enum {
    Absence,
    Tardy,
    Missed_Swipe
} Behavior;

- (void) generateCorrectiveActionDocumentFor: (EmployeeRecord *) employee forBehavior: (Behavior) behavior level: (int) level;

@end
