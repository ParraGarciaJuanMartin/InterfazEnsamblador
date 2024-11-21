// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: readKey.s
// Descripción: Leer un carácter desde el teclado y mostrarlo en pantalla
// Versión: 1.0
// ====================================================

    .data
buffer:     .space 1               // Espacio para almacenar el carácter leído
prompt:     .asciz "Presiona una tecla: " // Mensaje de prompt

    .text
    .global _start

// Punto de entrada principal
_start:
    // Mostrar mensaje de prompt
    ldr x0, =1                     // File descriptor: stdout
    ldr x1, =prompt                // Dirección del mensaje
    mov x2, #20                    // Longitud del mensaje
    mov x8, #64                    // syscall write
    svc #0                         // Llamada al sistema

    // Leer un carácter desde el teclado
    ldr x0, =0                     // File descriptor: stdin
    ldr x1, =buffer                // Dirección del buffer
    mov x2, #1                     // Leer un solo byte
    mov x8, #63                    // syscall read
    svc #0                         // Llamada al sistema

    // Mostrar el carácter leído
    ldr x0, =1                     // File descriptor: stdout
    ldr x1, =buffer                // Dirección del buffer
    mov x2, #1                     // Longitud: 1 byte
    mov x8, #64                    // syscall write
    svc #0                         // Llamada al sistema

    // Salida del programa
    mov x8, #93                    // syscall exit
    mov x0, #0                     // Código de salida
    svc #0