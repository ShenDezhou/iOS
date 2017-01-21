#pragma once
#include "cocos2d.h"
#include "Player.h"

NS_CC_BEGIN

class HelloWorld;

class HumanPlayer:public Player
{
public:

bool create();
void setAttacking(bool attacking);
};

NS_CC_END