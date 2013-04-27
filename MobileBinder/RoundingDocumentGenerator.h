/*
 *  MobileBinder
 *  Created by Andrew Patterson (nosrettap25@gmail.com), Alex Bruce and Sam Rang
 *  Copyright (c) 2013. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
@class RoundingLog;

/*
 *  Uses a RoundingLog to generate physical rounding log document
 */
@interface RoundingDocumentGenerator : NSObject

#define TABLE_PREFACE @"{\\rtf1\\ansi\\deff0\\trowd\\trgaph144"

#define TABLE_EPILOGUE @"}"

@property (nonatomic, strong) RoundingLog *log;

/*
 *  Uses a RoundingLog to generate a physical rounding log document and attach it to an e-mail (MFMailComposeViewController)
 */
- (MFMailComposeViewController *) generateRoundingDocumentFor: (RoundingLog *) log;

/*
 *  ABSTRACT METHOD
 *  Subclasses should return the template that will be used when generating the physical rounding document
 */
- (NSString *) getTemplate;

/*
 *  ABSTRACT METHOD
 *  Subclasses should fill the missing information in the template
 */
- (NSString *) writeDocumentUsingTemplate: (NSString *) template;

/*
 *  ABSTRACT METHOD
 *  Subclasses should return a string that will be used as the subject of the MFMailComposeViewController
 */
- (NSString *) getSubject;

/*
 *  ABSTRACT METHOD
 *  Subclasses sholud return a string that will be used as the body of the MFMailComposeViewController
 */
- (NSString *) getBody;

@end
