#import "RNNOverlayManager.h"
#import "RNNOverlayWindow.h"

NSUInteger const WINDOW_TAG = 100;
@implementation RNNOverlayManager

- (instancetype)init {
	self = [super init];
	_overlayWindows = [[NSMutableArray alloc] init];
	return self;
}

#pragma mark - public

- (void)showOverlay:(UIViewController*)viewController withOptions:(NSDictionary *)options {
	UIWindow* overlayWindow = [[RNNOverlayWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[_overlayWindows addObject:overlayWindow];
	viewController.view.backgroundColor = [UIColor clearColor];
	[overlayWindow setWindowLevel:UIWindowLevelNormal];
	[overlayWindow setRootViewController:viewController];
	if ([[options objectForKey:@"avoidKeyWindow"] boolValue] == YES) {
		[overlayWindow setHidden:NO];
		overlayWindow.tag = WINDOW_TAG;
	} else {
		[overlayWindow makeKeyAndVisible];
	}
}

- (void)dismissOverlay:(UIViewController*)viewController {
	UIWindow* overlayWindow = [self findWindowByRootViewController:viewController];
	[self detachOverlayWindow:overlayWindow];
}

#pragma mark - private

- (void)detachOverlayWindow:(UIWindow *)overlayWindow {
	[overlayWindow setHidden:YES];
	[overlayWindow setRootViewController:nil];
	if ([overlayWindow isKeyWindow]) {
		[overlayWindow resignKeyWindow];
		[self assignKeyWindow];
	}
	[_overlayWindows removeObject:overlayWindow];
}

- (void)assignKeyWindow {
	NSArray* windows = [[[UIApplication sharedApplication].windows reverseObjectEnumerator] allObjects];
	for (UIWindow* window in windows) {
		if (window.rootViewController && window.tag != WINDOW_TAG) {
			[window makeKeyAndVisible];
			return;
		}
	}
}

- (UIWindow *)findWindowByRootViewController:(UIViewController *)viewController {
	for (UIWindow* window in _overlayWindows) {
		if ([window.rootViewController isEqual:viewController]) {
			return window;
		}
	}

	return nil;
}

@end
