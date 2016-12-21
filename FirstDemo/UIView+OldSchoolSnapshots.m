#import "UIView+OldSchoolSnapshots.h"


@implementation UIView (OldSchoolSnapshots)

- (UIImage *)ar_snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return snapshotImage;
}

@end
