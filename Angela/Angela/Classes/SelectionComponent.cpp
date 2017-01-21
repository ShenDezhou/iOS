#include "SelectionComponent.h"
USING_NS_CC;
SelectionComponent::SelectionComponent(){
	selected = false;
}
SelectionComponent::~SelectionComponent(){}
CCString* SelectionComponent::ClassName(){
	return CCString::create("SelectionComponent");
}