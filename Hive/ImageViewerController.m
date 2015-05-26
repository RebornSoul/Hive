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
@property (nonatomic, weak) UIImage *scaleImage;
@property (nonatomic, assign) CGRect senderViewOriginalFrame;
@property (nonatomic, weak) UIWindow *applicationWindow;
@property (nonatomic) float animationDuration;

- (IBAction)didTouchScrollView:(id)sender;
@end

@implementation ImageViewerController

- (id) init {
	self = [super init];
	if (self) {
		_applicationWindow = [[[UIApplication sharedApplication] delegate] window];
		_animationDuration = 0.28f;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self performPresentAnimation];
    
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

- (UIImage*)rotateImageToCurrentOrientation:(UIImage*)image
{
	if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
	{
		UIImageOrientation orientation = ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ?UIImageOrientationLeft : UIImageOrientationRight;
		
		UIImage *rotatedImage = [[UIImage alloc] initWithCGImage:image.CGImage
														   scale:1.0
													 orientation:orientation];
		
		image = rotatedImage;
	}
	
	return image;
}

- (void)performPresentAnimation {
	self.view.alpha = 0.0f;
	
	UIImage *imageFromView = _scaleImage ? _scaleImage : [self getImageFromView:_senderViewForAnimation];
	imageFromView = [self rotateImageToCurrentOrientation:imageFromView];
	
	_senderViewOriginalFrame = [_senderViewForAnimation.superview convertRect:_senderViewForAnimation.frame toView:nil];
	
	CGRect screenBound = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenBound.size.width;
	CGFloat screenHeight = screenBound.size.height;
	
	UIView *fadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
	fadeView.backgroundColor = [UIColor clearColor];
	[_applicationWindow addSubview:fadeView];
	
	UIImageView *resizableImageView = [[UIImageView alloc] initWithImage:imageFromView];
	resizableImageView.frame = _senderViewOriginalFrame;
	resizableImageView.clipsToBounds = YES;
	resizableImageView.contentMode = UIViewContentModeScaleAspectFill;
	resizableImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
	[_applicationWindow addSubview:resizableImageView];
	_senderViewForAnimation.hidden = YES;
	
	void (^completion)() = ^() {
		self.view.alpha = 1.0f;
		resizableImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
		[fadeView removeFromSuperview];
		[resizableImageView removeFromSuperview];
	};
	
	[UIView animateWithDuration:_animationDuration animations:^{
		fadeView.backgroundColor = [UIColor blackColor];
	} completion:nil];
	
	float scaleFactor = (imageFromView ? imageFromView.size.width : screenWidth) / screenWidth;
	CGRect finalImageViewFrame = CGRectMake(0, (screenHeight/2)-((imageFromView.size.height / scaleFactor)/2), screenWidth, imageFromView.size.height / scaleFactor);
	
	[UIView animateWithDuration:_animationDuration animations:^{
		resizableImageView.layer.frame = finalImageViewFrame;
	} completion:^(BOOL finished) {
		completion();
	}];
}

- (UIImage*)getImageFromView:(UIView *)view {
	UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 2);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
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
