//
//  testNotification.m
//  MobileBinder
//
//  Created by Alexander Bruce on 1/29/13.
//  Copyright (c) 2013 Duke University. All rights reserved.
//

#import "testNotification.h"

@implementation testNotification



- (void)scheduleNotification
{
    
    
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil)
    {
        UILocalNotification *notif = [[cls alloc] init];
        notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:15];
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = @"Did you forget something?";
        notif.alertAction = @"Show me";
        notif.soundName = UILocalNotificationDefaultSoundName;
        notif.applicationIconBadgeNumber = 1;
        NSDictionary *userDict = nil;
        notif.userInfo = userDict;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}

@end
