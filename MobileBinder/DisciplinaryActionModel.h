/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
@class EmployeeRecord;

/*
 *  Creates appropriate documents for disciplining employees
 */
@interface DisciplinaryActionModel : NSObject

typedef enum {
    Absence,
    Tardy,
    Missed_Swipe
} Behavior;

/*
 *  Returns a MFMailComposeViewController that contains an attachment of an appropriate disciplinary document
 */
- (MFMailComposeViewController *) generateDisciplinaryActionDocumentFor: (EmployeeRecord *) employee forBehavior: (Behavior) behavior level: (int) level;

@end
