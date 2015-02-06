//
//  ImageViewerController.m
//  Hive
//
//  Created by Yury Nechaev on 06.02.15.
//  Copyright (c) 2015 Yury Nechaev. All rights reserved.
//

#import "ImageViewerController.h"

#define CENTER_XY_HACK 0

@interface ImageViewerController () <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) UIImageView *currentImageView;

- (IBAction)didTouchScrollView:(id)sender;
@end

@implementation ImageViewerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentImageView = [[UIImageView alloc] init];
    
    UIScrollView *scrollView;
    UIImageView *imageView;
    NSDictionary *viewsDictionary;
    
    scrollView  = self.scrollView;
    scrollView.delegate = self;
    imageView = self.currentImageView;
    
    [imageView setImage:self.thumbImage];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [scrollView addSubview:imageView];
    
    scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    viewsDictionary = NSDictionaryOfVariableBindings(scrollView, imageView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
    
#if CENTER_XY_HACK
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[scrollView]-(<=1)-[imageView]" options:NSLayoutFormatAlignAllCenterY metrics: 0 views:viewsDictionary]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[scrollView]-(<=1)-[imageView]" options:NSLayoutFormatAlignAllCenterX metrics: 0 views:viewsDictionary]];
#else
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics: 0 views:viewsDictionary]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics: 0 views:viewsDictionary]];
#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchScrollView:(id)sender {
    [self closeWindow];
}

- (void) closeWindow {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.currentImageView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
