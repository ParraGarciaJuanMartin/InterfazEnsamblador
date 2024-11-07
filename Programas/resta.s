// ============================================
// Programador: Parra García Juan Martín
// Fecha: 07/Nov/2024
// Programa: Resta de dos números
// Descripción: Resta dos números y muestra el resultado en consola
// Versión: 1.0
// ============================================
//
// using System;
//
// class Program
// {
//     static void Main()
//     {
//         int num1 = 50; // Primer número
//         int num2 = 30; // Segundo número
//         int resultado = num1 - num2; // Restar los dos números
//
//         Console.Write("Resultado: ");
//         Console.WriteLine(resultado); // Mostrar el resultado
//     }
// }

.section .data
num1:       .word 50            // Primer número (32 bits)
num2:       .word 30            // Segundo número (32 bits)
msg_result: .asciz "Resultado: "
newline:    .asciz "\n"

.section .bss
buffer: .space 32               // Espacio para almacenar la salida

.section .text
.global _start

_start:
    // Cargar números en registros de 64 bits para direcciones
    ldr x1, =num1              // Cargar dirección de num1 en x1
    ldr w1, [x1]               // Cargar valor de num1 en w1 (32 bits)
    ldr x2, =num2              // Cargar dirección de num2 en x2
    ldr w2, [x2]               // Cargar valor de num2 en w2 (32 bits)

    // Restar los dos números
    sub w0, w1, w2             // w0 = w1 - w2 (resultado)

    // Mostrar "Resultado: "
    adr x0, msg_result
    bl print_string

    // Convertir resultado a cadena y mostrar
    bl int_to_string
    bl print_string

    // Imprimir salto de línea
    adr x0, newline
    bl print_string

    // Salir del programa
    mov x0, #0
    mov x8, #93               // syscall exit
    svc #0

// --------------------------------------------
// Función para imprimir una cadena
// Entrada: x0 -> dirección de la cadena
// --------------------------------------------
print_string:
    mov x1, x0                // x1 = dirección de la cadena
    mov x2, #32               // Tamaño máximo a imprimir
    mov x8, #64               // syscall write
    mov x0, #1                // stdout (file descriptor)
    svc #0
    ret

// --------------------------------------------
// Función para convertir entero en w0 a cadena
// Salida: buffer (en .bss)
// --------------------------------------------
int_to_string:
    adr x1, buffer + 31       // Puntero al final del buffer
    mov w2, #0                // Contador de dígitos

convert_loop:
    mov w3, #10
    udiv w4, w0, w3           // w4 = w0 / 10
    msub w5, w4, w3, w0       // w5 = w0 - (w4 * 10)
    add w5, w5, #'0'          // Convertir dígito a ASCII
    strb w5, [x1, -1]!        // Almacenar carácter en buffer
    mov w0, w4                // Actualizar w0 con cociente
    cbnz w0, convert_loop     // Repetir si w0 != 0

    // Ajustar puntero al inicio del número
    add x0, x1, #1
    ret
