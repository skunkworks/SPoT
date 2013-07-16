//
//  FlickrPhotoTVC.h
//  Shutterbug
//
//  Created by Richard Shin on 7/14/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoTVC : UITableViewController

// of NSDictionary. Contains Flickr photo dictionaries
@property (strong, nonatomic) NSArray *photos;

// Must be overridden. Contains the reuse identifier of the table view's cell
@property (strong, nonatomic) NSString *cellIdentifier;

// Returns an cell title string for a given cell
- (NSString *)titleForRow:(NSUInteger)row;

// Returns a cell subtitle string for a given cell
- (NSString *)subtitleForRow:(NSUInteger)row;

// Returns a URL for the image to display in the table view cell
- (NSURL *)imageURLForRow:(NSUInteger)row;
@end
