#include "console.h"

void kernel_main(void) {
    clear_terminal();
    print_line("Hello, World!!");
    print_line("This is my OS Assignment");
    while(1) {}
}

