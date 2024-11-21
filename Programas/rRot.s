// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: rRot.s
// Descripción: (Manipulación de arreglos) Rotación de un arreglo (izquierda/derecha)
// Versión: 1.0
// ====================================================
// Código en C
//
// void rotateLeft(int* arr, int size, int steps) {
//     for (int s = 0; s < steps; s++) {
//         int temp = arr[0];
//         for (int i = 0; i < size - 1; i++) {
//             arr[i] = arr[i + 1];
//         }
//         arr[size - 1] = temp;
//     }
// }
//
// void rotateRight(int* arr, int size, int steps) {
//     for (int s = 0; s < steps; s++) {
//         int temp = arr[size - 1];
//         for (int i = size - 1; i > 0; i--) {
//             arr[i] = arr[i - 1];
//         }
//         arr[0] = temp;
//     }
// }
//
// ====================================================

.section .data
array:  .word 1, 2, 3, 4, 5   // Arreglo de enteros
size:   .word 5               // Tamaño del arreglo
steps:  .word 2               // Número de pasos a rotar

.section .text
.global _start

_start:
    // Cargar la dirección base del arreglo, tamaño y pasos
    ldr x0, =array           // Dirección base del arreglo en x0
    ldr x1, =size            // Dirección del tamaño del arreglo en x1
    ldr w1, [x1]             // Cargar el tamaño real en w1
    uxtw x1, w1              // Extender w1 a x1 para usarlo como 64 bits

    ldr x2, =steps           // Dirección de los pasos en x2
    ldr w2, [x2]             // Cargar el número de pasos en w2

    // Elegir rotación (izquierda o derecha)
    bl rotateLeft            // Llamar a rotación a la izquierda
    // bl rotateRight        // Descomenta para rotación a la derecha
    // Salir del programa
    mov x8, #93              // Código de sistema para salida en Linux
    svc #0                   // Llamada al sistema para terminar el programa

// rotateLeft(int* arr, int size, int steps)
rotateLeft:
    mov x3, x2               // Guardar los pasos en x3 (steps)

rotate_left_step:
    cmp x3, #0               // Si steps == 0, salir del bucle
    beq end_rotate_left

    // Guardar el primer elemento (temp = arr[0])
    ldr w4, [x0]             // w4 = arr[0]

    // Mover todos los elementos hacia la izquierda
    mov x5, #0               // Índice i = 0

shift_left:
    add x6, x5, #1           // Índice i + 1
    cmp x6, x1               // Si i + 1 == size, terminar
    bge finish_left_shift
    ldr w7, [x0, x6, lsl #2] // Cargar arr[i + 1] en w7
    str w7, [x0, x5, lsl #2] // Guardar arr[i + 1] en arr[i]
    add x5, x5, #1           // Incrementar índice i
    b shift_left

finish_left_shift:
    str w4, [x0, x5, lsl #2] // Guardar temp en arr[size - 1]

    // Decrementar pasos y repetir
    sub x3, x3, #1           // steps--
    b rotate_left_step

end_rotate_left:
    ret                      // Retornar al llamador

// rotateRight(int* arr, int size, int steps)
rotateRight:
    mov x3, x2               // Guardar los pasos en x3 (steps)

rotate_right_step:
    cmp x3, #0               // Si steps == 0, salir del bucle
    beq end_rotate_right

    // Guardar el último elemento (temp = arr[size - 1])
    sub x6, x1, #1           // Índice size - 1
    ldr w4, [x0, x6, lsl #2] // w4 = arr[size - 1]

    // Mover todos los elementos hacia la derecha
    mov x5, x6               // Índice i = size - 1

shift_right:
    sub x7, x5, #1           // Índice i - 1
    cmp x5, #0               // Si i == 0, terminar
    ble finish_right_shift
    ldr w8, [x0, x7, lsl #2] // Cargar arr[i - 1] en w8
    str w8, [x0, x5, lsl #2] // Guardar arr[i - 1] en arr[i]
    sub x5, x5, #1           // Decrementar índice i
    b shift_right

finish_right_shift:
    str w4, [x0]             // Guardar temp en arr[0]

    // Decrementar pasos y repetir
    sub x3, x3, #1           // steps--
    b rotate_right_step

end_rotate_right:
    ret                      // Retornar al llamador
