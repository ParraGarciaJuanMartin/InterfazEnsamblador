// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: rShift.s
// Descripción: (Operaciones de desplazamiento) Desplazamientos a la izquierda y derecha
// Versión: 1.1
// ====================================================
// Código en C
//
// int leftShift(int num, int shift) {
//     return num << shift;
// }
//
// int rightShift(int num, int shift) {
//     return num >> shift;
// }
//
// ====================================================


.section .data
num:    .word 8               // Número de ejemplo para los desplazamientos
shift:  .word 2               // Cantidad de bits a desplazar

.section .text
.global _start

_start:
    // Cargar el número y la cantidad de bits de desplazamiento
    ldr x0, =num              // Cargar la dirección de 'num' en x0
    ldr x1, =shift            // Cargar la dirección de 'shift' en x1
    ldr w0, [x0]              // Obtener el valor real de 'num' en w0 (desreferenciar la dirección)
    ldr w1, [x1]              // Obtener el valor real de 'shift' en w1 (desreferenciar la dirección)

    // Desplazamiento a la izquierda
    lsl w2, w0, w1            // w2 = w0 << w1 (desplazamiento a la izquierda)

    // Desplazamiento a la derecha lógico
    lsr w3, w0, w1            // w3 = w0 >> w1 (desplazamiento a la derecha lógico)

    // Salida del programa
    mov x8, #93               // Código de sistema para salida en Linux
    svc #0                    // Llamada al sistema para terminar el programa