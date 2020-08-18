#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MobpushPlugin.h"

FOUNDATION_EXPORT double mobpush_pluginVersionNumber;
FOUNDATION_EXPORT const unsigned char mobpush_pluginVersionString[];

