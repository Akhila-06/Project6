[BITS 16]
[ORG 0x7C00]

KERNEL_ADDR equ 0x1000


start:
    mov [BOOT_DRIVE], dl
    mov bp, 0x9000
    mov sp, bp

    call load_kernel
    call enter_protected_mode
    jmp $


load_kernel:
    mov bx, KERNEL_ADDR
    mov dh, 9               ; Number of sectors to read
    mov dl, [BOOT_DRIVE]     ; Boot drive from BIOS
    call disk_load
    ret

disk_load:
    pusha
    push dx
    mov ah, 0x02             ; BIOS read sector function
    mov al, 9            ; Number of sectors to read
    mov cl, 2                ; Start reading from sector 2
    mov ch, 0x00             ; Cylinder 0
    mov dh, 0x00             ; Head 0
    int 0x13                 ; Call BIOS
    jc disk_error             ; Jump if carry flag is set
    pop dx
    cmp al, dh               ; Compare sectors read
    jne sectors_error
    popa
    ret

disk_error:
    ; Handle disk error (you could display a message here)
    jmp $

sectors_error:
    ; Handle sector error (you could display a message here)
    jmp $

gdt_start:
    dq 0x0000000000000000
    dq 0x00cf9a000000ffff    ; Code segment
    dq 0x00cf92000000ffff    ; Data segment
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

enter_protected_mode:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1              ; Set PE bit
    mov cr0, eax
    jmp 0x08:protected_mode_entry

[BITS 32]
protected_mode_entry:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp
    
    ; Jump to the kernel entry point
    jmp KERNEL_ADDR  ; Jump directly to the kernel code where it is loaded

BOOT_DRIVE db 0
times 510 - ($ - $$) db 0
dw 0xAA55

