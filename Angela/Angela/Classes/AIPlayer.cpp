#include "AIPlayer.h"

USING_NS_CC;

bool AIPlayer::create()
{
    if (Player::create(CCString::create("castle2_def.png") )) {
        team = 2;
    }
    return true;
}

void AIPlayer::setAttacking(bool attacking) {
    //[super setAttacking:attacking];
	    if (attacking) {
        setDisplayFrame(CCSpriteFrameCache::sharedSpriteFrameCache()->spriteFrameByName("castle2_atk.png"));
    } else {
        setDisplayFrame(CCSpriteFrameCache::sharedSpriteFrameCache()->spriteFrameByName("castle2_def.png"));
    }
}