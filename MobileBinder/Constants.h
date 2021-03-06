/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>

/*
 * A global resource file
 */
@interface Constants : NSObject

#define IS_4_INCH_SCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/*
 * Progress Indicator
 */
#define PROGRESS_INDICATOR_LABEL_FONT_SIZE 23.5f
#define PROGRESS_INDICATOR_DETAIL_FONT_SIZE 16.0f
#define PROGRESS_INDICATOR_GREY_COLOR 0.24f
#define PROGRESS_INDICATOR_OPACITY 0.97f
#define PROGRESS_INDICATOR_FONT @"Georgia"


#define BIWEEKLY_PAYPERIOD_BEGIN_DATE_TYPEID 1
#define BIWEEKLY_PAYPERIOD_END_DATE_TYPEID 2
#define BIWEEKLY_PAYDATE_TYPEID 3
#define BIWEEKLY_ETIMECARD_LOCK_EMPLOYEE_TYPEID 4
#define BIWEEKLY_ETIMECARD_LOCK_SUPERVISOR_TYPEID 5
#define BIWEEKLY_GROSS_ADJUSTMENTS_TYPEID 6
#define BIWEEKLY_MANAGEMENTCENTER_FORMS_TYPEID 7
#define BIWEEKLY_DRH_HR_FORMS_TYPEID 8
#define BIWEEKLY_IFORMS_TYPEID 9
#define MONTHLY_MANAGEMENTCENTER_FORMS_TYPEID 10
#define MONTHLY_DRH_HR_FORMS_TYPEID 11
#define MONTHLY_LEAVE_ABSENCE_FORMS_TYPEID 12
#define MONTHLY_PAYEXCEPTION_FORMS_TYPEID 13
#define MONTHLY_IFORMS_TYPEID 14
#define MONTHLY_TIME_CLOSING_PTO_FORMS_TYPEID 15
#define MONTHLY_PAY_DATE_TYPEID 16

#define MANAGER_EMAIL_KEY @"managerEmailKey"
#define MANAGER_ID_ALREADY_ADDED_KEY @"managerIDAlreadyAddedKey"
#define MANAGER_ID @"managerID"
#define MANAGER_NAME @"managerName"
#define MANAGER_TITLE @"managerTitle"

#define KEYBOARD_HEIGHT 216.0f
#define TOOLBAR_HEIGHT 44

#define BACKGROUND_IMAGE_FILENAME @"BackgroundImage"

#define CUSTOM_DATA_FILE @"CustomResourcesData"


@end
