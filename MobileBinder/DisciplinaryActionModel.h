#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
@class EmployeeRecord;

@interface DisciplinaryActionModel : NSObject

typedef enum {
    Absence,
    Tardy,
    Missed_Swipe
} Behavior;

- (MFMailComposeViewController *) generateDisciplinaryActionDocumentFor: (EmployeeRecord *) employee forBehavior: (Behavior) behavior level: (int) level;

@end
