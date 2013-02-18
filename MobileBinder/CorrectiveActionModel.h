#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
@class EmployeeRecord;

@interface CorrectiveActionModel : NSObject

typedef enum {
    Absence,
    Tardy,
    Missed_Swipe
} Behavior;

- (MFMailComposeViewController *) generateCorrectiveActionDocumentFor: (EmployeeRecord *) employee forBehavior: (Behavior) behavior level: (int) level;

@end
