//
//  NuveiCashierCardScanner.m
//  NuveiCashierCardScannerSDK
//
//  Created by Michael Kessler on 09/09/2020.
//

#import "NuveiCashierCardScanner.h"
#import "CardIO.h"
@import WebKit;

typedef enum NuveiCashierCardScannerError {
    NuveiCashierCardScannerErrorCancel = 101,
    NuveiCashierCardScannerErrorMissingPermission = 102,
    NuveiCashierCardScannerErrorUnsupportedDevice = 103,
    NuveiCashierCardScannerErrorUnknown = 104,
} NuveiCashierCardScannerError_tag;

NSString *errorDescription(enum NuveiCashierCardScannerError error) {
    switch (error) {
        case NuveiCashierCardScannerErrorCancel:
            return @"User cancelled";
        case NuveiCashierCardScannerErrorMissingPermission:
            return @"No permission given to use camera";
        case NuveiCashierCardScannerErrorUnsupportedDevice:
            return @"Your device does not support this functionality";
        default:
            return @"Unknown error";
    }
}

@interface NuveiCashierCardScanner ()
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) CardIOView *cardIOView;
@end

@interface NuveiCashierCardScanner (WKScriptMessageHandler) <WKScriptMessageHandler>

@end

@interface NuveiCashierCardScanner (CardIOViewDelegate) <CardIOViewDelegate>

@end

@implementation NuveiCashierCardScanner {
@private NSString *messageName;
@private NSArray<NSString *> *hostWhiteList;
}

+ (instancetype)instance {
    static NuveiCashierCardScanner *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [NuveiCashierCardScanner new];
    });
    return __instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        messageName = @"scanCard";
        hostWhiteList = @[
            @"apmtest.gate2shop.com",// QA
            @"ppp-test.safecharge.com",// Integration
            @"secure.safecharge.com"// Production
        ];
    }
    return self;
}

+ (NSString *)versionNumber {
    return @FRAMEWORK_VERSION;
}

+ (void)connectTo:(WKWebView *)webView {
    [[NuveiCashierCardScanner instance] connectTo:webView];
}

- (void)connectTo:(WKWebView *)webView {
    if (!CardIOUtilities.canReadCardWithCamera) {
        return;
    }

    //self.rootViewController = viewController
    
    [webView.configuration.userContentController addScriptMessageHandler:self name:messageName];
    
    [CardIOUtilities preloadCardIO];
}

- (void)didScanWith:(CardIOCreditCardInfo *)cardInfo {
    NSString *expiryDate;
    if (cardInfo.expiryMonth > 0 && cardInfo.expiryYear > 0) {
        expiryDate = [NSString stringWithFormat:@"%02lu/%02lu", (unsigned long)cardInfo.expiryMonth, cardInfo.expiryYear%100];
    } else {
        expiryDate = @"";
    }
    NSString *cardNumber = (cardInfo.cardNumber != nil ? cardInfo.cardNumber : @"");
    
    NSString *js = [NSString stringWithFormat:@"\
                    window.postMessage({\
                    source: 'scanCard',\
                    status: 'OK',\
                    cardHolderName: '',\
                    cardNumber: '%@',\
                    expDate: '%@',\
                    cvv: ''\
                    },\"*\");"
                    , cardNumber
                    , expiryDate];
    [self.webView evaluateJavaScript:js completionHandler:nil];
}

- (void)didFailWith:(enum NuveiCashierCardScannerError)error {
    NSString *js = [NSString stringWithFormat:@"\
                    window.postMessage({\
                    source: 'scanCard',\
                    status: 'NOK',\
                    errorCode: '%d',\
                    errorMessage: '%@'\
                    },\"*\");"
                    , error
                    , errorDescription(error)];
    [self.webView evaluateJavaScript:js completionHandler:nil];
}

@end

@implementation NuveiCashierCardScanner (WKScriptMessageHandler)

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if (message.name != messageName || message.webView.URL.host == nil || ![hostWhiteList containsObject:message.webView.URL.host]) {
        return;
    }

#ifdef DEBUG
    NSLog(@"[SCAN] %s: message.body = %@", __PRETTY_FUNCTION__, message.body);
#endif

    if (![CardIOUtilities canReadCardWithCamera]) {
        [self didFailWith:NuveiCashierCardScannerErrorUnsupportedDevice];
        return;
    }

    WKWebView *webView = message.webView;
    self.webView = webView;

    CardIOView *cardIOView = [[CardIOView alloc] initWithFrame:webView.frame];
    cardIOView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    cardIOView.delegate = self;
    cardIOView.hideCardIOLogo = YES;
    [webView.superview addSubview:cardIOView];
    self.cardIOView = cardIOView;

    CGRect scannerFrame = cardIOView.cameraPreviewFrame;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    CGFloat y = webView.frame.size.height >= CGRectGetMaxY(scannerFrame) + 80 ? CGRectGetMaxY(scannerFrame) : CGRectGetMaxY(scannerFrame) - 40;
    cancelButton.frame = CGRectMake(CGRectGetMinX(scannerFrame), y, 100, 40);
    [cardIOView addSubview:cancelButton];
}

- (void)cancel {
    [self.cardIOView removeFromSuperview];
    [self didFailWith:NuveiCashierCardScannerErrorCancel];
}

@end

@implementation NuveiCashierCardScanner (CardIOViewDelegate)

- (void)cardIOView:(CardIOView *)cardIOView didScanCard:(CardIOCreditCardInfo *)cardInfo {
    #ifdef DEBUG
        NSLog(@"[SCAN] %s: cardInfo = %@", __PRETTY_FUNCTION__, cardInfo);
    #endif
    [self.cardIOView removeFromSuperview];
    [self didScanWith:cardInfo];
}

@end

////
////  NuveiCashierCardScanner.swift
////  NuveiCashierCardScannerSDK
////
////  Created by Michael Kessler on 23/06/2020.
////  Copyright © 2020 SafeCharge. All rights reserved.
////
//
//import UIKit
//import WebKit
////import SCCardIO
//
//private let messageName2 = "scanCard"
//private let hostWhiteList2 = [
//    "apmtest.gate2shop.com",// QA
//    "ppp-test.safecharge.com",// Integration
//    "secure.safecharge.com"// Production
//]
//
//public class NuveiCashierCardScanner: NSObject {
//    private static let instance = NuveiCashierCardScanner()
//
//    //private weak var rootViewController: UIViewController?
//    private weak var webView: WKWebView?
//    private weak var cardIOView: CardIOView?
//
//    public static func connect(to webView: WKWebView) {
//        NuveiCashierCardScanner.instance.connect(to: webView)
//    }
//
//    //public func connect(to webView: WKWebView, viewController: UIViewController) {
//    private func connect(to webView: WKWebView) {
//        guard CardIOUtilities.canReadCardWithCamera() else {
//            return
//        }
//
//        //self.rootViewController = viewController
//
//        webView.configuration.userContentController.add(self, name: messageName)
//
//        CardIOUtilities.preloadCardIO()
//    }
//
//    private func didScan(with cardInfo: CardIOCreditCardInfo) {
//        let expiryDate: String
//        if cardInfo.expiryMonth > 0, cardInfo.expiryYear > 0 {
//            expiryDate = String(format: "%02d/%02d", cardInfo.expiryMonth, cardInfo.expiryYear%100)
//        } else {
//            expiryDate = ""
//        }
//
//        let js = """
//        window.postMessage({
//        source: 'scanCard',
//        status: 'OK',
//        cardHolderName: '\(cardInfo.cardholderName ?? "")',
//        cardNumber: '\(cardInfo.cardNumber ?? "")',
//        expDate: '\(expiryDate)',
//        cvv: '\(cardInfo.cvv ?? "")'
//        },"*");
//        """
//        webView?.evaluateJavaScript(js, completionHandler: nil)
//    }
//
//    private func didFail(with error: SCCardScannerError) {
//        let js = """
//        window.postMessage({
//        source: 'scanCard',
//        status: 'NOK',
//        errorCode: '\(error.code)',
//        errorMessage: '\(error.description)'
//        },"*");
//        """
//        webView?.evaluateJavaScript(js, completionHandler: nil)
//    }
//}
//
//extension NuveiCashierCardScanner: WKScriptMessageHandler {
//    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        guard
//            message.name == messageName,
//            //let rootViewController = rootViewController,
//            let webView = message.webView,
//            let urlHost = webView.url?.host,
//            hostWhiteList.contains(urlHost)
//            else { return }
//
//        debugPrint("[SCAN] \(#function): message.body = \(message.body)")
//
//        guard CardIOUtilities.canReadCardWithCamera() else {
//            didFail(with: .unsupportedDevice)
//            return
//        }
//
//        self.webView = webView
//
//        let cardIOView = CardIOView(frame: webView.frame)
//        cardIOView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        cardIOView.delegate = self
//        cardIOView.hideCardIOLogo = true
//        webView.superview?.addSubview(cardIOView)
//        self.cardIOView = cardIOView
//
//        let scannerFrame = cardIOView.cameraPreviewFrame
//        let cancelButton = UIButton.init(type: .custom)
//        cancelButton.setTitle("Cancel", for: .normal)
//        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
//        let y = webView.frame.height >= scannerFrame.maxY + 80 ? scannerFrame.maxY : scannerFrame.maxY - 40
//        cancelButton.frame = CGRect(x: scannerFrame.minX, y: y, width: 100, height: 40)
//        cardIOView.addSubview(cancelButton)
//
//        //if let paymentViewController = CardIOPaymentViewController(paymentDelegate: self) {
//        //    paymentViewController.collectCVV = false
//        //    paymentViewController.collectExpiry = false
//        //    paymentViewController.scanExpiry = true
//        //    paymentViewController.collectCardholderName = false
//        //    paymentViewController.hideCardIOLogo = true
//        //    paymentViewController.disableManualEntryButtons = true
//        //    paymentViewController.modalPresentationStyle = .fullScreen
//        //    rootViewController.present(paymentViewController, animated: true)
//        //}
//    }
//
//    @objc func cancel() {
//        cardIOView?.removeFromSuperview()
//        didFail(with: .cancel)
//    }
//}
//
////extension NuveiCashierCardScanner: CardIOPaymentViewControllerDelegate {
////    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
////        debugPrint("[SCAN] \(#function)")
////        paymentViewController.dismiss(animated: true)
////        didFail(with: .cancel)
////    }
////
////    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
////        debugPrint("[SCAN] \(#function): cardInfo = \(cardInfo!)")
////        paymentViewController.dismiss(animated: true)
////        didScan(with: cardInfo)
////    }
////}
//
//extension NuveiCashierCardScanner: CardIOViewDelegate {
//    public func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
//        debugPrint("[SCAN] \(#function): cardInfo = \(cardInfo!)")
//        cardIOView.removeFromSuperview()
//
//        didScan(with: cardInfo)
//    }
//}
//
//fileprivate enum SCCardScannerError {
//    case cancel, missingPermission, unsupportedDevice, unknown
//
//    var code: Int {
//        switch self {
//        case .cancel:
//            return 101
//        case .missingPermission:
//            return 102
//        case .unsupportedDevice:
//            return 103
//        case .unknown:
//            return 104
//        }
//    }
//
//    var description: String {
//        switch self {
//        case .cancel:
//            return "User cancelled"
//        case .missingPermission:
//            return "No permission given to use camera"
//        case .unsupportedDevice:
//            return "Your device does not support this functionality"
//        case .unknown:
//            return "Unknown error"
//        }
//    }
//}
