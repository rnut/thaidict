//
//  FeedbackService.h
//  TrueMovie
//
//  Created by tu on 2/13/56 BE.
//
//

#import <Foundation/Foundation.h>

@protocol FeedbackServiceDelegate

@required
- (void) feedbackCompleteWithDictionaray:(NSDictionary *) dict;
- (void) feedbackFailedWithError:(NSError *) error;
@end

@interface FeedbackService : NSObject

@property (assign) id <FeedbackServiceDelegate> delegate;

- (void) sendFeedBackWithDictionary:(NSDictionary *) dict_;


@end
