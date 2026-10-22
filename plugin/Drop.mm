#include "Drop.hpp"
#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>
@interface StepCompassDropTarget : NSObject {
@public
  NSView *view;
  void *owner;
  DropCallback callback;
  Class original;
}
@end
@implementation StepCompassDropTarget
@end
static char associationKey;
static NSDragOperation entered(id, SEL, id<NSDraggingInfo> sender) {
  return [[sender draggingPasteboard] canReadObjectForClasses:@[ [NSURL class] ]
                                                      options:@{
                                                        NSPasteboardURLReadingFileURLsOnlyKey : @YES
                                                      }]
             ? NSDragOperationCopy
             : NSDragOperationNone;
}
static BOOL prepare(id, SEL, id<NSDraggingInfo>) {
  return YES;
}
static BOOL perform(id self, SEL, id<NSDraggingInfo> sender) {
  StepCompassDropTarget *t = objc_getAssociatedObject(self, &associationKey);
  NSArray *urls =
      [[sender draggingPasteboard] readObjectsForClasses:@[ [NSURL class] ]
                                                 options:@{
                                                   NSPasteboardURLReadingFileURLsOnlyKey : @YES
                                                 }];
  NSURL *url = [urls firstObject];
  if (!url || !t || !t->callback)
    return NO;
  t->callback(t->owner, [[url path] UTF8String]);
  return YES;
}
void *installDrop(uintptr_t native, void *owner, DropCallback cb) {
  NSView *view = (NSView *)native;
  if (!view)
    return nullptr;
  Class original = object_getClass(view);
  NSString *name = [@"StepCompassFileDrop_" stringByAppendingString:NSStringFromClass(original)];
  Class subclass = NSClassFromString(name);
  if (!subclass) {
    subclass = objc_allocateClassPair(original, [name UTF8String], 0);
    class_addMethod(subclass, @selector(draggingEntered:), (IMP)entered, "Q@:@");
    class_addMethod(subclass, @selector(draggingUpdated:), (IMP)entered, "Q@:@");
    class_addMethod(subclass, @selector(prepareForDragOperation:), (IMP)prepare, "B@:@");
    class_addMethod(subclass, @selector(performDragOperation:), (IMP)perform, "B@:@");
    objc_registerClassPair(subclass);
  }
  StepCompassDropTarget *t = [[StepCompassDropTarget alloc] init];
  t->view = view;
  t->owner = owner;
  t->callback = cb;
  t->original = original;
  objc_setAssociatedObject(view, &associationKey, t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  object_setClass(view, subclass);
  [view registerForDraggedTypes:@[ NSPasteboardTypeFileURL ]];
  return t;
}
void removeDrop(void *ptr) {
  StepCompassDropTarget *t = (StepCompassDropTarget *)ptr;
  if (!t)
    return;
  t->callback = nullptr;
  [t->view unregisterDraggedTypes];
  object_setClass(t->view, t->original);
  objc_setAssociatedObject(t->view, &associationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [t release];
}
