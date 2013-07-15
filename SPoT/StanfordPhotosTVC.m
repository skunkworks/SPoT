//
//  StanfordPhotosTVC.m
//  SPoT
//
//  Created by Richard Shin on 7/15/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "StanfordPhotosTVC.h"
#import "FlickrFetcher.h"

@interface StanfordPhotosTVC ()
@property (strong, nonatomic) NSMutableDictionary *photosByTags; // NSString key, NSNumber value
@end

@implementation StanfordPhotosTVC

@synthesize photos = _photos;

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    // Any time photos gets updated, we need to update photosByTags as well.
    _photosByTags = nil;
    [self.tableView reloadData];
}

- (NSDictionary *)photosByTags {
    if (!_photosByTags) {
        _photosByTags = [[NSMutableDictionary alloc] init];

        // self.photo is an NSArray of NSDictionary. We want to parse this data and sort it into photo tags and the number
        // of photos with a tag. We store this in photosByTags.
        for (id item in self.photos) {
            NSDictionary *photoDictionary = (NSDictionary *)item;
            NSArray *tags = [photoDictionary[FLICKR_TAGS] componentsSeparatedByString:@" "];
            
            for (NSString *tag in tags) {
                if (!self.photosByTags[tag]) {
                    // Add tag to our dictionary
                    [self.photosByTags setValue:@(1) forKey:tag];
                }
                else
                {
                    NSNumber *count = self.photosByTags[tag];
                    self.photosByTags[tag] = @(count.intValue + 1);
                }
            }
        }
    }
    return _photosByTags;
}

// Tag name, capitalized
- (NSString *)titleForRow:(NSUInteger)row
{
    [self.photosByTags count];
    return @"";
}

// Number of photos with this tag
- (NSString *)subtitleForRow:(NSUInteger)row
{
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stanford Photo" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    // Get square image
    NSData *data = [[NSData alloc] initWithContentsOfURL:[FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatSquare]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    cell.imageView.image = image;
    
    return cell;
}

- (void)viewDidLoad
{
    self.photos = [FlickrFetcher stanfordPhotos];
}

@end
