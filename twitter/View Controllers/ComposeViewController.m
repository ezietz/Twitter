//
//  ComposeViewController.m
//  twitter
//
//  Created by ezietz on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tweetButton:(id)sender {
    //[[APIManager shared] postStatusWithText:(NSString *) completion:^(Tweet *, NSError *) {
    [[APIManager shared] postStatusWithText: self.composedTweet.text completion:^(Tweet * tweet, NSError * error) {
        if (tweet) {
            
            // Add a property for the array of tweets and set it when the network call succeeds.
            NSLog(@"posted tweet!");
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
            
        }
        else {
            NSLog(@"failed to post tweet: %@", error.localizedDescription);
        }
    }];
    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
