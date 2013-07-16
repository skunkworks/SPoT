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
@property (strong, nonatomic) NSArray *recentlyViewedPhotos; // of RecentlyViewedFlickrPhoto *
@end

@implementation RecentlyViewedPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.recentlyViewedPhotos = [RecentlyViewedFlickrPhoto getAll];
}

@end
