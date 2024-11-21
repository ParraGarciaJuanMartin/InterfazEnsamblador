// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: seed.s
// Descripción: Generación de números pseudoaleatorios 
//              utilizando una semilla.
// Versión: 2.2
// ====================================================
// Código en C#:
//
// int random(int* seed) {
//     *seed = (*seed * 1664525 + 1013904223) % (1 << 31);
//     return *seed;
// }
//
// ====================================================

// Sección de datos
    .data
seed:   .word   12345               // Semilla inicial, modificable

// Sección de texto
    .text
    .global random                  // Función exportada
    .global _start                  // Punto de entrada

// Función random
random:
    ldr x0, =seed                  // x0 = dirección de la semilla
    ldr w1, [x0]                   // w1 = valor de la semilla

    // Multiplicación por 1664525
    movz w2, #0x1965              // Cargar los 16 bits bajos
    movk w2, #0x0001, lsl #16     // Cargar los 16 bits altos
    mul w1, w1, w2                // w1 *= 1664525

    // Suma 1013904223
    movz w2, #0x4223              // Cargar los 16 bits bajos
    movk w2, #0x3C6E, lsl #16     // Cargar los 16 bits altos
    add w1, w1, w2                // w1 += 1013904223

    // Modulo 2^31
    mov w2, #31
    mov w3, #1
    lsl w3, w3, w2                // w3 = 1 << 31
    udiv w4, w1, w3               // División para obtener el cociente
    msub w1, w4, w3, w1           // w1 = w1 - (w4 * w3)

    // Guardar nuevo valor de la semilla
    str w1, [x0]                  // seed = w1

    // Retornar el nuevo valor de la semilla
    mov w0, w1
    ret

// Punto de entrada _start
_start:
    bl random                     // Llamada a la función random
    mov x8, #93                   // syscall exit
    mov x0, #0                    // exit code
    svc #0