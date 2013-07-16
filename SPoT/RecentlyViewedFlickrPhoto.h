//
//  RecentlyViewedPhotos.h
//  SPoT
//
//  Created by Richard Shin on 7/15/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//
// getAll: returns an array of RecentlyViewedFlickrPhoto *

#import <Foundation/Foundation.h>

@interface RecentlyViewedFlickrPhoto : NSObject
@property (strong, nonatomic) NSString *id;
@property (readonly, nonatomic) NSDate *viewed; // Set automatically when id is set
- (void)synchronize; // Saves record to permanent store
+ (NSArray *)getAll; // of RecentlyViewedFlickrPhoto *
@end
