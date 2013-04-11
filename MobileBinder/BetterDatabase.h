#import <Foundation/Foundation.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface BetterDatabase : NSObject

+ (BetterDatabase *) sharedDocumentHandler;

//- (id) performWithDocumentAndReturn:(id (^)(UIManagedDocument *)) onDocumentReady;

- (void)performWithDocument:(OnDocumentReady)onDocumentReady;

- (void) save: (UIManagedDocument *) document;

- (void) save: (UIManagedDocument *) document withCompletion: (void (^) (void)) block;

- (void) lock;

- (void) unlock;

@end