//
//  TrueStatisticHelper.h
//  StatRequest
//
//  Created by Satit on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//  Current version 3.0.2     22-11-2012

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

enum TMNetworkConnection {
    TMNetworkNA = 0,
    TMNetworWifi,
    TMNetwork3g
} typedef TMNetworkConnection;

enum TMStatHelperOption {
    TMStatHelperNoOption = 0,
    TMStatHelperGoogleAnalytics = 1
//    TMStatHelperMoreOption = 1 << 1
} typedef TMStatHelperOption;

/** 
 * Checking network availability.
 */
 
UIKIT_EXTERN int isNetworkAvailable();

/**
 * Checking network connection type.
 */

UIKIT_EXTERN TMNetworkConnection currentNetworkConnection(); 

/**
 * TMStatisticHelper prepare when app finished launch method.
 */

UIKIT_EXTERN void startStatDaemonWithOption(TMStatHelperOption /* option */);

/**
 * Method for set location parameter. ** optional **
 */

UIKIT_EXTERN void statWithLocation(CLLocation * /* location */);

/**
 * Method for set user's SSO ID parameter. ** optional **
 */
 
UIKIT_EXTERN void statWithSSOID(NSString * /* ssoID */);

@protocol TMStatisticDelegate;

/** 
 Helper for send activation to statistic server.
 */

@interface TMStatisticHelper : NSObject 

///-----------------------------
/// @name Properties
///-----------------------------

/**
 Ivar for specified app id. ** required **
 
 set to -1 for develop mode.
 */

@property (strong) NSString * appID;

/**
 Ivar for keep record User's ssoID. ** optional **
 */

@property (strong) NSString * ssoID;

/**
 * Current latitude which use for keep stat. ** optional **
 */

@property double latitude;

/**
 * Current latitude which use for keep stat. ** optional **
 */

@property double longitude;

///-----------------------------
/// @name Class Methods
///-----------------------------

/**
 For check version of TMStatisticHelper class.
 */

+ (NSString *)currentVersion;

/** 
 Method for start statistic action. 
 
 @warning Call this method when your app launched and set key window already. 
*/

+ (void)startStatDaemon;

/** 
 Method for start statistic action with set delegate object. 
 
 @param delegate object implemented delegate method.
 
 @warning Call this method when your app launched and set key window already. 
 */

+ (void)startStatDaemonWithDelegate:(id <TMStatisticDelegate>)delegate;

/**
 Call for stop all module's action and clear memory.
 
 @warning (*important*): Please do not forget call this method in your -applicationWillTerminate: appDelegate method for memory conservation.
*/

+ (void)stopStatDaemon;

/**
 Refresh corner left truehits webview will disappear when changed window's rootViewController.
 */

+ (void)refreshTrueHitsWebviewOnCurrentWindow;

@end

/**
 The TMStatisticDelegate protocol is defined for recieved action while helper working in any state.
 */

@protocol TMStatisticDelegate <NSObject>

@optional

/** 
 This method was performed when truehits's webview is added on key windows of your application.
 
 @warning You can implement this method for fix some case of problem such as can't see webview because its
 behind other view, change position follow application orientation, etc.
*/

- (void)truehitsActivatedWithWebView:(UIWebView *)truehitsWebview  NS_DEPRECATED_IOS(3_0, 4_3);

/**
 Method for make sure statistic was sent to TrueHits.
 */

- (void)truehitsActivated:(BOOL)yesOrNo;

@end


@interface TMStatisticHelper (tmo20)

/**
 Get instance of TMStatistic class.
 */

+ (TMStatisticHelper *)sharedInstance;

/**
 Prepare stat helper for project.
*/
 
+ (void)prepareStatHelper;

/**
 Keep stat methods by all parameter.
 
 @param pageName ** Require ** Page's name keeping stat as string type.
 @param cid ** Optional ** Showing content's id on page.
 @param cts ** Optional ** Showing content's source (CMS, UCC, others...).
 @param title ** Optional ** Showing ViewController's title or showing on navigation bar. If is be nil, assumed same as pageName.
 @param refURL ** Option ** String value which navigate to showing page.
 
 */

+ (void)trackingPageViewName:(NSString *)pageName withContentID:(NSString *)cid 
               contentSource:(NSString *)cts pageTitle:(NSString *)title 
                referenceURL:(NSString *)refURL;

/**
 Keep stat method witout content, reference parameter.
 
 @param pageName ** Require ** Page's name keeping stat as string type.
 @param title ** Optional ** Showing ViewController's title or showing on navigation bar. If is be nil, assumed same as pageName.
 
 */

+ (void)trackingPageViewName:(NSString *)pageName pageTitle:(NSString *)titleOrNil;


@end