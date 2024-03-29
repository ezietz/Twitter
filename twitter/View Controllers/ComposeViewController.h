//
//  ComposeViewController.h
//  twitter
//
//  Created by ezietz on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

// whoever conforms to this protocol must have this method
// protocol allows us to send data back to the base controller
@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *composedTweet;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

//  ComposeViewController.h

NS_ASSUME_NONNULL_END
