// RUN: %clang_cc1 -emit-llvm -g -triple x86_64-apple-darwin10 %s -o - | FileCheck %s
// rdar://problem/13359718
// Substitute the actual type for a method returning instancetype.
@interface NSObject
+ (id)alloc;
- (id)init;
- (id)retain;
@end

@interface Foo : NSObject
+ (instancetype)defaultFoo;
@end

@implementation Foo
+(instancetype)defaultFoo {return 0;}
// CHECK: ![[FOO:[0-9]+]] = metadata {{.*}}; [ DW_TAG_structure_type ] [Foo]
// CHECK: metadata !{metadata !"0x2e\00+[Foo defaultFoo]\00+[Foo defaultFoo]\00\00[[@LINE-2]]\00{{[^,]*}}"{{, [^,]+, [^,]+}}, metadata ![[TYPE:[0-9]+]]
// CHECK: ![[TYPE]] = {{.*}} metadata ![[RESULT:[0-9]+]], null, null, null} ; [ DW_TAG_subroutine_type ]
// CHECK: ![[RESULT]] = metadata {{.*}}{metadata ![[FOOPTR:[0-9]+]],
// CHECK: ![[FOOPTR]] = {{.*}}, metadata ![[FOO]]}{{.*}}[ DW_TAG_pointer_type ] {{.*}} [from Foo]
@end


int main (int argc, const char *argv[])
{
  Foo *foo = [Foo defaultFoo];
  return 0;
}
