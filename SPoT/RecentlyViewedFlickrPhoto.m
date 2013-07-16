//
//  RecentlyViewedPhotos.m
//  SPoT
//
//  Created by Richard Shin on 7/15/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "RecentlyViewedFlickrPhoto.h"
#import "FlickrFetcher.h"

@interface RecentlyViewedFlickrPhoto ()
@property (readwrite, nonatomic) NSDate *viewed;
@end

@implementation RecentlyViewedFlickrPhoto

#define RECENTLY_VIEWED_PHOTOS_KEY @"RecentlyViewedFlickrPhotos_All"
#define RECENT_PHOTO_DICT_KEY @"Photo_Dictionary"
#define RECENT_PHOTO_VIEWED_KEY @"Photo_ViewedDate"
#define MAX_RECENT_PHOTOS 25

- (void)setPhotoDictionary:(NSDictionary *)photoDictionary {
    _photoDictionary = photoDictionary;
    _viewed = [NSDate date];
}

// Non-designated initializer meant to convert a property list into an instance of RecentlyViewedFlickrPhoto
- (id)initFromPropertyList:(id)plist
{
    self = [self init];
    
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionaryFromUserDefaults = (NSDictionary *)plist;
            _viewed = dictionaryFromUserDefaults[RECENT_PHOTO_VIEWED_KEY];
            _photoDictionary = dictionaryFromUserDefaults[RECENT_PHOTO_DICT_KEY];
            if (!_photoDictionary || !_viewed) self = nil;
        }
    }
    
    return self;
}

// Print a nice representation of this record for debugging purposes
- (NSString *)description
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    return [NSString stringWithFormat:@"Photo ID %@ at %@", self.photoDictionary[FLICKR_PHOTO_ID], [dateFormat stringFromDate:self.viewed]];
}

// Used to convert instances of RecentlyViewedFlickrPhoto into a property list. Use initFromPropertyList: to reverse this
- (id)asPropertyList
{
    return @{RECENT_PHOTO_DICT_KEY : self.photoDictionary, RECENT_PHOTO_VIEWED_KEY : self.viewed};
}

// Store record in permanent store
- (void)synchronize
{
    // Get our records from permanent store (or make a fresh dictionary if none found)
    NSMutableDictionary *mutableDictionaryFromUserSettings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:RECENTLY_VIEWED_PHOTOS_KEY] mutableCopy];
    if (!mutableDictionaryFromUserSettings) mutableDictionaryFromUserSettings = [[NSMutableDictionary alloc] init];
    
    // Add this record to the dictionary (or update if it already exists)
    mutableDictionaryFromUserSettings[self.photoDictionary[FLICKR_PHOTO_ID]] = [self asPropertyList];
    
    // Prune earliest record if we've reached max recently viewed photo records
    if ([mutableDictionaryFromUserSettings count] > MAX_RECENT_PHOTOS) {
        RecentlyViewedFlickrPhoto *earliestPhoto = self;
        
        // Have to iterate through all records and find the earliest photo record to pop
        for (id plist in mutableDictionaryFromUserSettings) {
            RecentlyViewedFlickrPhoto *photo = [[RecentlyViewedFlickrPhoto alloc] initFromPropertyList:plist];

            // If there's an invalid record found, remove it instead!
            if (!photo) {
                earliestPhoto = photo;
                break;
            } else if (photo.viewed < earliestPhoto.viewed) {
                earliestPhoto = photo;
            }
        }
        
        [mutableDictionaryFromUserSettings removeObjectForKey:earliestPhoto.photoDictionary[FLICKR_PHOTO_ID]];
    }
    
    // Propagate any modifications to the permanent store
    [[NSUserDefaults standardUserDefaults] setObject:mutableDictionaryFromUserSettings forKey:RECENTLY_VIEWED_PHOTOS_KEY];
}

// Returns an NSArray of all recently viewed photos, sorted descending
+ (NSArray *)getAll
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    NSDictionary *dictionaryFromUserSettings = [[NSUserDefaults standardUserDefaults] dictionaryForKey:RECENTLY_VIEWED_PHOTOS_KEY];
    for (id plist in [dictionaryFromUserSettings allValues]) {
        RecentlyViewedFlickrPhoto *rvfp = [[RecentlyViewedFlickrPhoto alloc] initFromPropertyList:plist];
        if (rvfp) [mutableArray addObject:rvfp];
    }
    
    return [mutableArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 valueForKey:@"viewed"] compare:[obj1 valueForKey:@"viewed"]];
    }];
}

@end
