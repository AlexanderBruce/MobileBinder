////
////  LocalDelegate.m
////  MobileBinder
////
////  Created by Alexander Bruce on 4/16/13.
////  Copyright (c) 2013 Duke University. All rights reserved.
////
//
//#import "LocalDelegate.h"
//
//@implementation LocalDelegate
//
//@end
//
//
////
////  LocalPushAppDelegate.m
////  LocalPush
////
//
//@interface ToDoItem : NSObject  {
//    NSInteger year;
//    NSInteger month;
//    NSInteger day;
//    NSInteger hour;
//    NSInteger minute;
//    NSInteger second;
//    NSString *eventName;
//}
//
//@property (nonatomic, readwrite) NSInteger year;
//@property (nonatomic, readwrite) NSInteger month;
//@property (nonatomic, readwrite) NSInteger day;
//@property (nonatomic, readwrite) NSInteger hour;
//@property (nonatomic, readwrite) NSInteger minute;
//@property (nonatomic, readwrite) NSInteger second;
//@property (nonatomic, copy) NSString *eventName;
//
//@end
//
//@implementation ToDoItem
//
//@synthesize year, month, day, hour, minute, second, eventName;
//
//@end
//
//#import "LocalPushAppDelegate.h"
//
//@implementation LocalPushAppDelegate
//
//@synthesize window;
//
//#define ToDoItemKey @"EVENTKEY1"
//#define MessageTitleKey @"MSGKEY1"
//
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSLog(@"application: didFinishLaunchingWithOptions:");
//    // Override point for customization after application launch
//    
//    UILocalNotification *localNotif = [launchOptions
//                                       objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    
//    if (localNotif) {
//        NSString *itemName = [localNotif.userInfo objectForKey:ToDoItemKey];
//        //  [viewController displayItem:itemName]; // custom method
//        application.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
//        NSLog(@"has localNotif %@",itemName);
//    }
//    else {
//        [[UIApplication sharedApplication] cancelAllLocalNotifications];
//        NSDate *now = [NSDate date];
//        NSLog(@"now is %@",now);
//        NSDate *scheduled = [now dateByAddingTimeInterval:120] ; //get x minute after
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        
//        unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
//        NSDateComponents *comp = [calendar components:unitFlags fromDate:scheduled];
//        
//        NSLog(@"scheduled is %@",scheduled);
//        
//        ToDoItem *todoitem = [[ToDoItem alloc] init];
//        
//        todoitem.day = [comp day];
//        todoitem.month = [comp month];
//        todoitem.year = [comp year];
//        todoitem.hour = [comp hour];
//        todoitem.minute = [comp minute];
//        todoitem.eventName = @"Testing Event";
//        
//        [self scheduleNotificationWithItem:todoitem interval:1];
//        NSLog(@"scheduleNotificationWithItem");
//    }
//    [window makeKeyAndVisible];
//    return YES;
//}
//
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
//    NSLog(@"application: didReceiveLocalNotification:");
//    NSString *itemName = [notif.userInfo objectForKey:ToDoItemKey];
//    NSString *messageTitle = [notif.userInfo objectForKey:MessageTitleKey];
//    // [viewController displayItem:itemName]; // custom method
//    [self _showAlert:itemName withTitle:messageTitle];
//    NSLog(@"Receive Local Notification while the app is still running...");
//    NSLog(@"current notification is %@",notif);
//    
//    
//    application.applicationIconBadgeNumber = notif.applicationIconBadgeNumber-1;
//    
//}
//
//- (void) _showAlert:(NSString*)pushmessage withTitle:(NSString*)title
//{
//    
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:pushmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
//    if (alertView) {
//        [alertView release];
//    }
//}
//
//
//- (void)scheduleNotificationWithItem:(ToDoItem *)item interval:(int)minutesBefore {
//    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
//    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
//    [dateComps setDay:item.day];
//    [dateComps setMonth:item.month];
//    [dateComps setYear:item.year];
//    [dateComps setHour:item.hour];
//    [dateComps setMinute:item.minute];
//    NSDate *itemDate = [calendar dateFromComponents:dateComps];
//    [dateComps release];
//    
//    
//    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//    if (localNotif == nil)
//        return;
//    localNotif.fireDate = [itemDate dateByAddingTimeInterval:-(minutesBefore*60)];
//    NSLog(@"fireDate is %@",localNotif.fireDate);
//    localNotif.timeZone = [NSTimeZone defaultTimeZone];
//    
//    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ in %i minutes.", nil),
//                            item.eventName, minutesBefore];
//    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
//    
//    localNotif.soundName = UILocalNotificationDefaultSoundName;
//    localNotif.applicationIconBadgeNumber = 1;
//    //  NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
//    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:item.eventName,ToDoItemKey, @"Local Push received while running", MessageTitleKey, nil];
//    localNotif.userInfo = infoDict;
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//    NSLog(@"scheduledLocalNotifications are %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
//    [localNotif release];
//}
//
//- (NSString *) checkForIncomingChat {
//    return @"javacom";
//};
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    NSLog(@"Application entered background state.");
//    // UIBackgroundTaskIdentifier bgTask is instance variable
//    // UIInvalidBackgroundTask has been renamed to UIBackgroundTaskInvalid
//    NSAssert(self->bgTask == UIBackgroundTaskInvalid, nil);
//    
//    bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [application endBackgroundTask:self->bgTask];
//            self->bgTask = UIBackgroundTaskInvalid;
//        });
//    }];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        while ([application backgroundTimeRemaining] > 1.0) {
//            NSString *friend = [self checkForIncomingChat];
//            if (friend) {
//                UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//                if (localNotif) {
//                    localNotif.alertBody = [NSString stringWithFormat:
//                                            NSLocalizedString(@"%@ has a message for you.", nil), friend];
//                    localNotif.alertAction = NSLocalizedString(@"Read Msg", nil);
//                    localNotif.soundName = @"alarmsound.caf";
//                    localNotif.applicationIconBadgeNumber = 1;
//                    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Your Background Task works",ToDoItemKey, @"Message from javacom", MessageTitleKey, nil];
//                    localNotif.userInfo = infoDict;
//                    [application presentLocalNotificationNow:localNotif];
//                    [localNotif release];
//                    friend = nil;
//                    break;
//                }
//            }
//        }
//        [application endBackgroundTask:self->bgTask];
//        self->bgTask = UIBackgroundTaskInvalid;
//    });
//}
//
//
//- (void)dealloc {
//    [window release];
//    [super dealloc];
//}
//
//
//@end
