#pragma once
#include <cstdint>
using DropCallback = void (*)(void *, const char *);
#ifdef __APPLE__
void *installDrop(uintptr_t view, void *owner, DropCallback cb);
void removeDrop(void *drop);
#else
inline void *installDrop(uintptr_t, void *, DropCallback) {
  return nullptr;
}
inline void removeDrop(void *) {}
#endif
