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
//    self.composedTweet.delegate = self;
    
    // Do any additional setup after loading the view.
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    // TODO: Check the proposed new text character count
//    // Allow or disallow the new text
//    int characterLimit = 140;
//
//    // Construct what the new text would be if we allowed the user's latest edit
//    NSString *newText = [self.text stringByReplacingCharactersInRange:range withString:text];
//    
//    // TODO: Update Character Count Label
//    // The new text should be allowed? True/False
//    return newText.length < characterLimit;
//}

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

@end
