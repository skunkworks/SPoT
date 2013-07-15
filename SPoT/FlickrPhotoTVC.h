//
//  FlickrPhotoTVC.h
//  Shutterbug
//
//  Created by Richard Shin on 7/14/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoTVC : UITableViewController
@property (strong, nonatomic) NSArray *photos; // of NSDictionary
@property (strong, nonatomic) NSString *cellIdentifier;

- (NSString *)titleForRow:(NSUInteger)row;
- (NSString *)subtitleForRow:(NSUInteger)row;
- (NSURL *)imageURLForRow:(NSUInteger)row;
@end
