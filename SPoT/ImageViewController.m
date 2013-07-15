//
//  ImageViewController.m
//  Shutterbug
//
//  Created by Richard Shin on 7/14/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ImageViewController
- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [self resetImage];
}

- (UIImageView *)imageView {
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = .2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
}

- (void)resetImage
{
    // Do nothing if scrollView is nil, e.g. when someone sets imageUrl before the scrollView outlet is set
    if (self.scrollView) {
        // Blank out existing values first
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        // These will be set to nil if imageUrl or imageData is invalid
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        // Successfully pulled image, so display it
        if (image) {
            // Must reset zoom scale when changing images, since if the scroll view is already zoomed it would stay zoomed
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            // Can't forget to set the imageView's frame to its new natural size
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
}

@end
