
//  KTPlay.h
//  KTPlay SDK
//
//  Created by KTPlay on 13-5-1
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/// 奖励数据项，包含奖励所需数据
@interface KTRewardItem : NSObject

/// 奖励名称
@property (nonatomic,copy) NSString * name;

/** 奖励ID
 *
 *  奖励ID用于标识奖励类型，如金币（GOLD），由开发者自己在开发者后台设定。
 */
@property (nonatomic,copy) NSString * typeId;

/** 奖励值
 *
 * 奖励具体数值
 */
@property (nonatomic) long long value;
@end


/// KTPlay发放奖励回调，由游戏实现最终的奖励发放。
typedef  void (^KTDidDispatchRewardsBlock)(NSArray * rewards);

/// KTPlay窗口显示时的回调
typedef  void (^KTViewDidAppearBlock)();

/// KTPlay窗口关闭时的回调
typedef  void (^KTViewDidDisappearBlock)();

/// KTPlay收到新动态或已读新动态时的回调
typedef  void (^KTActivityStatusChangedBlock)(BOOL hasNewActivity);

/// KTPlay主类
@interface KTPlay : NSObject

/// @name 初始化
/** 初始化KTPlay SDK
 *
 *  startWithAppKey方法必须在游戏AppDelgate的didFinishLaunchWithOptions方法中调用
 *  @param appKey KTPlay开发者网站新建应用时生成的App Key
 **/
+(void)startWithAppKey:(NSString *)appKey;

/// @name 打开/关闭KTPlay窗口
/** 显示KTPlay窗口
 *  @param parentView 要显示KTPlay窗口的父View
 */
+(void)showInView:(UIView *)parentView;


/** 关闭KTPlay窗口
 *
 * 通常情况下不需要调用此方法，因为KTPlay窗口会由玩家主动关闭。
 */
+(void)dismiss;


/** 设置KTPlay要展示在哪个父view上
 * 默认情况下，KTPlay会使用 [[[[UIApplication sharedApplication] keyWindow] rootViewController] view] 作为父view，
 * 如果遇到异常，请调用此方法设置自己的view
 */
+(void)setKTParentView:(UIView *)parentView;


/// @name 设置各类回调
/** 设置发放奖励的回调
 *
 * 此方法必须被调用以完成奖励的最终发放，关于奖励的使用方法请参考SDK接入指南。
 * @param block 发放奖励回调
 */
+(void)setDidDispatchRewardsBlock:(KTDidDispatchRewardsBlock)block;

/** 设置KTPlay窗口显示时的回调
 *  @param block KTPlay窗口显示时的回调
 */
+(void)setViewDidAppearBlock:(KTViewDidAppearBlock)block;

/** 设置KTPlay窗口关闭时的回调
 *  @param block KTPlay窗口关闭时的回调
 */
+(void)setViewDidDisappearBlock:(KTViewDidDisappearBlock)block;


/** 设置KTPlay收到新动态时的回调
 *
 * 关于新动态的作用和提示方法请参考DK接入指南
 *  @param block KTPlay窗口关闭时的回调
 */
+(void)setActivityStatusChangedBlock:(KTActivityStatusChangedBlock)block;


/// @name 其他辅助方法
/** 判断KTPlay是否可用
 *
 * KTPlay不可用的情况包括：<br/>
 * 1、设备不被支持 <br/>
 * 2、开发者网站后台关闭了KT功能
 * @return KTPlay是否可用
 */
+(BOOL)isEnabled;

/** 判断KTPlay窗口是否正在显示
 * @return KTPlay窗口是否正在显示
 */
+(BOOL)isShowing;

/** 设置截图旋转角度
 *
 * 一般情况下不需要此方法，在截图角度不正常时（可能由游戏引擎或会游戏开发方式导致），再调用此方法进行调整。
 * @param degrees 截图旋转角度（注意，是角度而不是弧度，取值如90,180等）
 */
+(void)setScreenshotRotation:(float)degrees;

/** 处理SNS客户端返回的信息
 *
 * 为确保SNS（微信，QQ，新浪微博等）功能正确使用，需要在游戏AppDelegate的openURL方法中调用此方法
 * @param url AppDelegate的openURL方法中传入的url，直接使用。
 */
+(void)handleOpenURL:(NSURL *)url;



@end





