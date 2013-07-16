//
//  RecentlyViewedPhotosTVC.m
//  SPoT
//
//  Created by Richard Shin on 7/15/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "RecentlyViewedPhotosTVC.h"
#import "RecentlyViewedFlickrPhoto.h"
#import "FlickrFetcher.h"

@interface RecentlyViewedPhotosTVC ()
@end

@implementation RecentlyViewedPhotosTVC

// Must be overridden. Contains the reuse identifier of the table view's cell
- (NSString *)cellIdentifier {
    return @"Recently Viewed Photo";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Get recent photos and sort them from latest to earliest
    NSArray *recentlyViewedPhotos = [[RecentlyViewedFlickrPhoto getAll] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 valueForKey:@"viewed"] compare:[obj1 valueForKey:@"viewed"]];
    }];
    
    // And set the model appropriately
    self.photos = [recentlyViewedPhotos valueForKey:@"photoDictionary"];
}

#pragma mark - Table View data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    // Get the model corresponding to this cell
    NSDictionary *photoDictionary = self.photos[indexPath.row];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    cell.imageView.image = image;
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self titleForRow:indexPath.row];
    
    return cell;
}

@end
