#include "console.h"

#define VGA_BUFFER ((char*)0xb8000)
#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define TAB_WIDTH 8

void clear_terminal() {
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        VGA_BUFFER[i * 2] = ' ';      
        VGA_BUFFER[i * 2 + 1] = 0x0A; 
    }
}

void print_character(char c) {
    static int cursor_pos = 0;

    if (c == '\n') {
        cursor_pos += VGA_WIDTH - (cursor_pos % VGA_WIDTH);

    } else {
        if (cursor_pos < VGA_WIDTH * VGA_HEIGHT) {
            VGA_BUFFER[cursor_pos * 2] = c;  
            VGA_BUFFER[cursor_pos * 2 + 1] = 0x0A;
            cursor_pos++;
        }
    }

    if (cursor_pos >= VGA_WIDTH * VGA_HEIGHT) {
        cursor_pos = 0;
    }
}

void print_string(char* str) {
    while (*str) {
        print_character(*str++);
    }
}

void print_line(char* str) {
    print_string(str);
    print_character('\n');
//    print_character('\t');
   // 
}

