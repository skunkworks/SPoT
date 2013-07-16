//
//  RecentlyViewedPhotos.m
//  SPoT
//
//  Created by Richard Shin on 7/15/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "RecentlyViewedFlickrPhoto.h"

@interface RecentlyViewedFlickrPhoto ()
@property (readwrite, nonatomic) NSDate *viewed;
@end

@implementation RecentlyViewedFlickrPhoto

#define RECENTLY_VIEWED_PHOTOS_KEY @"RecentlyViewedFlickrPhotos_All"
#define RECENT_PHOTO_ID_KEY @"RecentlyViewedFlickrPhotos_Identifier"
#define RECENT_PHOTO_VIEWED_KEY @"RecentlyViewedFlickrPhotos_ViewedDate"
#define MAX_RECENT_PHOTOS 25

- (void)setId:(NSString *)id {
    _id = id;
    _viewed = [NSDate date];
}

- (id)initFromPropertyList:(id)plist
{
    self = [self init];
    
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *photoDictionary = (NSDictionary *)plist;
            _id = photoDictionary[RECENT_PHOTO_ID_KEY];
            _viewed = photoDictionary[RECENT_PHOTO_VIEWED_KEY];
            if (!_id || !_viewed) self = nil;
        }
    }
    
    return self;
}

- (NSString *)description
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    return [NSString stringWithFormat:@"Photo ID %@ at %@", self.id, [dateFormat stringFromDate:self.viewed]];
}

- (id)asPropertyList
{
    return @{RECENT_PHOTO_ID_KEY : self.id,
             RECENT_PHOTO_VIEWED_KEY : self.viewed};
}

- (void)synchronize
{
    NSMutableDictionary *mutableDictionaryFromUserSettings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:RECENTLY_VIEWED_PHOTOS_KEY] mutableCopy];
    if (!mutableDictionaryFromUserSettings) mutableDictionaryFromUserSettings = [[NSMutableDictionary alloc] init];
    
    mutableDictionaryFromUserSettings[self.id] = [self asPropertyList];
    
    if ([mutableDictionaryFromUserSettings count] > MAX_RECENT_PHOTOS) {
        RecentlyViewedFlickrPhoto *earliestPhoto = self;
        for (id plist in mutableDictionaryFromUserSettings) {
            RecentlyViewedFlickrPhoto *photo = [[RecentlyViewedFlickrPhoto alloc] initFromPropertyList:plist];
            if (photo && photo.viewed < earliestPhoto.viewed) {
                earliestPhoto = photo;
            }
        }
        [mutableDictionaryFromUserSettings removeObjectForKey:earliestPhoto.id];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableDictionaryFromUserSettings forKey:RECENTLY_VIEWED_PHOTOS_KEY];
}

+ (NSArray *)getAll
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    NSDictionary *dictionaryFromUserSettings = [[NSUserDefaults standardUserDefaults] dictionaryForKey:RECENTLY_VIEWED_PHOTOS_KEY];
    for (id plist in [dictionaryFromUserSettings allValues]) {
        RecentlyViewedFlickrPhoto *rvfp = [[RecentlyViewedFlickrPhoto alloc] initFromPropertyList:plist];
        if (rvfp) [mutableArray addObject:rvfp];
    }
    
    return [mutableArray copy];
}

#pragma mark - Sorting
@end
