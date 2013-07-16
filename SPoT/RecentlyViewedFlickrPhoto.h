//
//  RecentlyViewedPhotos.h
//  SPoT
//
//  Created by Richard Shin on 7/15/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentlyViewedFlickrPhoto : NSObject

// Flickr photo dictionary
@property (strong, nonatomic) NSDictionary *photoDictionary;

 // Saves record to permanent store
- (void)synchronize;

// Returns an NSArray of all recently viewed photos, sorted descending
+ (NSArray *)getAll; // of RecentlyViewedFlickrPhoto *
@end
