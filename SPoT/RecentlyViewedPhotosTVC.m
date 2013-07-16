//
//  RecentlyViewedPhotosTVC.m
//  SPoT
//
//  Created by Richard Shin on 7/15/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "RecentlyViewedPhotosTVC.h"
#import "RecentlyViewedFlickrPhoto.h"

@interface RecentlyViewedPhotosTVC ()
@end

@implementation RecentlyViewedPhotosTVC

// Must be overridden. Contains the reuse identifier of the table view's cell
- (NSString *)cellIdentifier {
    return @"Recently Viewed Photo";
}

- (NSString *)imageViewSegueIdentifier {
    return @"Show Recent Photo";
}

- (void)updateModel
{
    // Get recent photos and sort them from latest to earliest
    NSArray *recentlyViewedPhotos = [RecentlyViewedFlickrPhoto getAll];
    
    // And set the model appropriately
    self.photos = [recentlyViewedPhotos valueForKey:@"photoDictionary"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateModel];
}

@end
