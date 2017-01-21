#include "main.h"
#include "AppDelegate.h"
#include "CCEGLView.h"

USING_NS_CC;

int APIENTRY _tWinMain(HINSTANCE hInstance,
                       HINSTANCE hPrevInstance,
                       LPTSTR    lpCmdLine,
                       int       nCmdShow)
{
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

    // create the application instance
    AppDelegate app;
    CCEGLView* eglView = CCEGLView::sharedOpenGLView();
    eglView->setViewName("HelloCpp");
#if IPADMINI2
	eglView->setFrameSize(2048, 1536);
#elif IPAD
	eglView->setFrameSize(1024,768);
#elif IPHONE5
	eglView->setFrameSize(1136,640);
#elif IPHONE4
	eglView->setFrameSize(960,640);
#else
    eglView->setFrameSize(480, 320);
#endif

    return CCApplication::sharedApplication()->run();
}
