//  QRDelegate.h
//  QRDecode
//
//  Created by david on 10/22/21.
//
#import <Cocoa/Cocoa.h>

// QRCodeDecoder calls its delegate back through this.
@protocol QRDelegate <NSObject>
- (void)qrValue:(nullable NSString *)s error:(nullable NSError *)error;
@end

