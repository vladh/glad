/*
 * No extensions core GL header only
 *
 * GLAD: $GLAD --out-path=$tmp --api="gl:core" --extensions="" c --loader --header-only
 * COMPILE: $GCC $test -o $tmp/test -I$tmp/include -ldl
 * RUN: $tmp/test
 */

#define GLAD_GL_IMPLEMENTATION
#include <glad/gl.h>

int main(void) {
    (void) gladLoadGLInternalLoader();
    return 0;
}
