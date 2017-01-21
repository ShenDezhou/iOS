#pragma once

#include "ArmorHomeScene.h"
//#include "HelloWorldScene.h"
#include "GameOverScene.h"
#include "SplashScene.h"
#include "Constant.h"
#include "ArmorHomeScene.h"
#include "UserPayScene.h"
#include "HelpScene.h"
#include "CCBattle.h"
//#include "ServerScene.h"

#if !(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "iconv/iconv.h"
#endif
//#define IPAD
//#ifdef IPAD
//#define MARGIN  (52 / CC_CONTENT_SCALE_FACTOR())
//#else
//#define MARGIN  (26 / CC_CONTENT_SCALE_FACTOR())
//#endif