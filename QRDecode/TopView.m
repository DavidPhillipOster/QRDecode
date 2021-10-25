//  ViewController.m
//  QRDecode
//
//  Created by david on 10/22/21.
//

#import "TopView.h"

@interface TopView ()
@property IBOutlet NSImageView *imageView;
@property IBOutlet NSScrollView *scrollView;
@end

@implementation TopView

- (void)layout {
  [super layout];
  CGRect bounds = self.bounds;
  CGRect top, bottom;
  CGRectDivide(bounds, &bottom, &top, 64, CGRectMinYEdge);
  bottom.size.height -= 5;
  self.scrollView.frame = bottom;
  top.origin.y += 5;
  top.size.height -= 5;
  self.imageView.frame = top;
}

@end

