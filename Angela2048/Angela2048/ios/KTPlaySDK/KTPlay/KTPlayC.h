//  KTPlayC.h
//  KTPlay SDK
//  Created by KTPlay on 13-7-12
//

#ifndef __kt239_sdk__KryptaniumC__
#define __kt239_sdk__KryptaniumC__

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    
    /// 奖励数据项，包含奖励所需数据
    class KTRewardItemC
    {
    public:
        
        /** 奖励名称
         */
        const char *name;
        
        /** 奖励ID
         *
         *  奖励ID用于标识奖励类型，如金币（GOLD），由开发者自己在开发者后台设定。
         */

        const char *typeId;
        
        
        /** 奖励值
         *
         * 奖励具体数值
         */
        unsigned long value;
        KTRewardItemC()
        {
            name = NULL;
            typeId = NULL;
            value = 0;
        }
    };
    
    /** KTPlay发放奖励回调，由游戏实现最终的奖励发放。
     */
    typedef void (*KTDispatchRewardsCallback)(KTRewardItemC * pRewardArray, int length);
    
    /// KTPlay窗口显示时的回调
    typedef void (*KTViewDidAppearCallback)();
    
    /// KTPlay窗口关闭时的回调
    typedef void (*KTViewDidDisappearCallback)();
    
    /// KTPlay收到新动态时的回调
    typedef void (*KTActivityStatusChangedCallback)(bool activityStatusChanged);
    
    /// KTPlay主类
    class KTPlayC
    {
    public:
        
        /** 设置KTPlay窗口显示时的回调
         *  @param appearCallback KTPlay窗口显示时的回调
         */
        static void setViewDidAppearCallback(KTViewDidAppearCallback appearCallback);
        
        /** 设置KTPlay窗口显示时的回调
         *  @param block KTPlay窗口显示时的回调
         */
        static void setViewDidDisappearCallback(KTViewDidDisappearCallback disappearCallback);
        
        /** 设置发放奖励的回调
         * 此方法必须被调用以完成奖励的最终发放，关于奖励的使用方法请参考SDK接入指南。
         * @param dispatchRewardsCallback 发放奖励回调
         */
        static void setDidDispatchRewardsCallback(KTDispatchRewardsCallback dispatchRewardsCallback);
        
        /** 设置KTPlay收到新动态时的回调
         * 关于新动态的作用和提示方法请参考DK接入指南
         *  @param activityStatusChangedCallback KTPlay收到新动态或已读新动态时的回调
         */
        static void setActivityStatusChangedCallback(KTActivityStatusChangedCallback activityStatusChangedCallback);
        
        /** 显示KTPlay窗口
         */
        static void show();
        
        /** 关闭KTPlay窗口
         * 通常情况下不需要调用此方法，因为KTPlay窗口会由玩家主动关闭。
         */
        static void dismiss();
        
        /** 判断KTPlay是否可用
         * KTPlay不可用的情况包括：</br>
         * 1、设备不被支持 <br/>
         * 2、开发者网站后台关闭了KT功能
         * @return KTPlay是否可用
         */
        static bool isEnabled();
        
        /** 判断KTPlay窗口是否正在显示
         * @return KTPlay窗口是否正在显示
         */
        static bool isShowing();
        
        /** 处理SNS客户端返回的信息
         * 为确保SNS（微信，QQ，新浪微博等）功能正确使用，需要在游戏AppDelegate的openURL方法中调用此方法
         * @param url AppDelegate的openURL方法中传入的url，直接使用。
         */

        static void setScreenshotRotation(float degrees);
    };
    
#ifdef __cplusplus
}
#endif

#endif /* defined(__kt239_sdk__KryptaniumC__) */
