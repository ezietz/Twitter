//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DetailsView.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate, ComposeViewControllerDelegate>
@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // view controller becomes table view's dataSource and delegate in viewDidLoad
    self.tableView.dataSource = self; // data Source for tableview is the object that gives the table view the thing it'll display
    self.tableView.delegate = self; // delegate responds to touch events, how many things to make
    
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Get timeline
}

- (void) fetchTweets {
    // [APIManager shared] grabs an instance of the API Manager
    // make an API request
    [[APIManager shared] getHomeTimelineWithParam:nil WithCompletion:^(NSArray *tweets, NSError *error) {
        // API manager calls the completion handler passing back data
        if (tweets) {
             // numberOfRowsInSection returns the number of items returned from the API
//            self.isMoreDataLoading = false;
            // View controller stores that data passed into the completion handler
            self.tweetsArray = tweets;
            // Reload the table view
            [self.tableView reloadData];
            /*
             NSLog(@"😎😎😎 Successfully loaded home timeline");
             for (NSDictionary *dictionary in tweets) {
             NSString *text = dictionary[@"text"];
             NSLog(@"%@", text);
             }
             
             }
             */
        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        
    }];
}

// table view asks its dataSource for numberOfRowsInSection and cellForRowAtIndexPath
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // cellForRowAtIndexPath returns an instance of the custom cell with that reuse identifier with its elements populated with data at the index asked for
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweetsArray[indexPath.row];
    cell.tweet = tweet;
    User *tweetUser = tweet.user;
    
    [cell refreshData];    
    return cell;
}

 // numberOfRowsInSection returns the number of items returned from the API
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsArray.count;
}

- (IBAction)clickedLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// #pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ComposerView"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        
    } else {
        // Gets appropiate data corresponding to the tweet that the user selected
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweetsArray[indexPath.row];
        
        // Get the new view controller using [segue destinationViewController].
        DetailsView *detailsView = [segue destinationViewController];
        
        // Pass the selected object to the new view controller
        detailsView.tweet = tweet;
    }
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweetsArray addObject:tweet];
    [self.tableView reloadData];
}

-(void)loadMoreData{
    Tweet *lastTweet = [self.tweetsArray lastObject];
    // NSNumber  *aNum = [NSNumber numberWithInteger: [string integerValue]];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:lastTweet.idStr];
    long lastTweetString = [myNumber longValue];
    long actualID = lastTweetString - 1;
    NSNumber *maxID = @(actualID);
    NSDictionary *parameter = @{@"max_id": maxID};
    [[APIManager shared] getHomeTimelineWithParam:(NSDictionary  *)parameter WithCompletion:^(NSArray *tweets, NSError *error){
    
        if (error != nil) {
        }
        else
        {
            // Update flag
            self.isMoreDataLoading = false;
            [self.tweetsArray addObjectsFromArray:tweets];
            // ... Use the new data to update the data source ...

            // Reload the tableView now that there is new data
            [self.tableView reloadData];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading) {
        // self.isMoreDataLoading = true;
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;

        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
    }
    }
}

@end
