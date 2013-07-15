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
@property (strong, nonatomic) NSMutableDictionary *tags; // Key = NSString, Value = NSArray of NSDictionary
@property (strong, nonatomic) NSArray *rowTags; // of NSString
@end

@implementation StanfordPhotosTVC

@synthesize photos = _photos;

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    // Any time photos gets updated, we need to update tags as well
    _tags = nil;
    [self.tableView reloadData];
}

// Key is the tag name, value is an array of Flickr photo metadata (as NSDictionary objects)
- (NSDictionary *)tags {
    if (!_tags) {
        _tags = [[NSMutableDictionary alloc] init];

        // self.photo is an NSArray of NSDictionary. We want to parse this and sort it by tag name
        for (id item in self.photos) {
            NSDictionary *photoDictionary = (NSDictionary *)item;
            NSArray *tokenizedTags = [photoDictionary[FLICKR_TAGS] componentsSeparatedByString:@" "];
            
            for (NSString *tag in tokenizedTags) {
                if (!_tags[tag]) {
                    [_tags setValue:@[photoDictionary] forKey:tag];
                }
                else
                {
                    _tags[tag] = [_tags[tag] arrayByAddingObject:photoDictionary];
                }
            }
        }
        
        // We have to use a separate array to keep track of which tag corresponds to which row. We can't rely on
        // using the allKeys method of tags because NSDictionary doesn't guarantee that it will return the same order
        // each time it's invoked.
        _rowTags = [self.tags allKeys];
    }
    return _tags;
}

// Tag name, capitalized
- (NSString *)titleForRow:(NSUInteger)row
{
    return [[self.rowTags[row] description] capitalizedString];
}

// Number of photos with this tag
- (NSString *)subtitleForRow:(NSUInteger)row
{
    NSString *tagName = self.rowTags[row];
    return [NSString stringWithFormat:@"%d photos", [self.tags[tagName] count]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tags count];
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
