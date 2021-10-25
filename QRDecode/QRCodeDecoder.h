//  QRDelegate.h
//  QRDecode
//
//  Created by david on 10/22/21.
//
#import <Cocoa/Cocoa.h>
#import "QRDelegate.h"

// Create and retain it. Set its delegate, and call qrCodeInImage:
// it will call its delegate back if it succeeds.
@interface QRCodeDecoder :NSObject
@property(weak) id<QRDelegate> delegate;

- (void)qrCodeInImage:(NSImage *)image;
@end

