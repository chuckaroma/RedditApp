//
//  RedditPost.h
//  RedditApp
//
//  Created by Chad Zeluff on 5/16/14.
//  Copyright (c) 2014 Chad Zeluff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedditPost : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *imageURL;

@end
