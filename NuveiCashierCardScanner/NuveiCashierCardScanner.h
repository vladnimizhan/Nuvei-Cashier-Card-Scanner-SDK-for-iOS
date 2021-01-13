//
//  NuveiCashierCardScanner.h
//  NuveiCashierCardScannerSDK
//
//  Created by Michael Kessler on 09/09/2020.
//

#import <Foundation/Foundation.h>

@class WKWebView;

NS_ASSUME_NONNULL_BEGIN

@interface NuveiCashierCardScanner : NSObject

+ (void)connectTo:(WKWebView *)webView;
+ (NSString *)versionNumber;

@end

//@interface SCCardIOCreditCardInfo : NSObject
//
//@end
//
//@interface SCCardIOUtilities : NSObject
//
//+ (BOOL)canReadCardWithCamera;
//+ (void)preloadCardIO;
//
//@end

NS_ASSUME_NONNULL_END
