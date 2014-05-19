//
//  PostsTableViewController.m
//  RedditApp
//
//  Created by Chad Zeluff on 5/16/14.
//  Copyright (c) 2014 Chad Zeluff. All rights reserved.
//

#import "PostsTableViewController.h"
#import "RedditPost.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PostsTableViewController ()

@property (nonatomic, strong) NSArray *postsArray;

@end

@implementation PostsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Reddit Posts";
    
    NSLog(@"it's about to begin...");
    
    [self refresh];
}

- (void)refresh
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://reddit.com/.json"]];
    
    [[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *array = [dictionary valueForKeyPath:@"data.children"];
        
        NSMutableArray *mutArray = [NSMutableArray array];
        
        for(NSDictionary *postDict in array)
        {
            RedditPost *newPost = [[RedditPost alloc] init];
            newPost.title = [postDict valueForKeyPath:@"data.title"];
            newPost.imageURL = [NSURL URLWithString:[postDict valueForKeyPath:@"data.url"]];
            
            [mutArray addObject:newPost];
        }
        
        self.postsArray = [NSArray arrayWithArray:mutArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        NSLog(@"we're done!");
        
    }] resume];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.postsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostIdentifier"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostIdentifier"];
    }
    
    RedditPost *post = self.postsArray[indexPath.row];
    
    cell.textLabel.text = post.title;
    [cell.imageView setImageWithURL:post.imageURL placeholderImage:[UIImage imageNamed:@"reddit"]];
    
    return cell;
}







@end
