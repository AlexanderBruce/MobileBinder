/*
  *  MobileBinder
  *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
  *  Copyright (c) 2013. All rights reserved.
  */
#import <Foundation/Foundation.h>

/*
 *  A CoreData object that can be used as the underlying backing of a rounding log
 */
@protocol RoundingLogManagedObjectProtocol <NSObject>

@property (nonatomic, retain) id contents;

@end
