// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: gnirts.s
// Descripción: (Manipulación de arreglos) Invertir los elementos de un arreglo
// Versión: 1.1
// ====================================================
// Código en C
//
// void reverseArray(int* arr, int size) {
//     int start = 0;
//     int end = size - 1;
//     while (start < end) {
//         int temp = arr[start];
//         arr[start] = arr[end];
//         arr[end] = temp;
//         start++;
//         end--;
//     }
// }
//
// ====================================================

.section .data
array:  .word 1, 2, 3, 4, 5   // Arreglo de enteros
size:   .word 5               // Tamaño del arreglo

.section .text
.global _start

_start:
    // Cargar la dirección base del arreglo y su tamaño
    ldr x0, =array           // Dirección base del arreglo en x0
    ldr x1, =size            // Dirección del tamaño del arreglo en x1
    ldr w1, [x1]             // Cargar el tamaño real en w1
    uxtw x1, w1              // Extender w1 a x1 como 64 bits

    // Llamar a reverseArray
    bl reverseArray          // Llamar a reverseArray

    // Salir del programa
    mov x8, #93              // Código de sistema para salida en Linux
    svc #0                   // Llamada al sistema para terminar el programa

// reverseArray(int* arr, int size)
reverseArray:
    mov x2, x0               // x2 apunta al inicio del arreglo (start)
    mov x3, x0               // x3 apunta al final del arreglo
    add x3, x3, x1, lsl #2   // x3 = &arr[size-1] (final del arreglo)

reverse_loop:
    cmp x2, x3               // Comparar los punteros (start < end)
    bge end_reverse          // Si start >= end, salir del bucle

    // Intercambiar arr[start] con arr[end]
    ldr w5, [x2]             // Cargar arr[start] en w5
    ldr w6, [x3]             // Cargar arr[end] en w6
    str w6, [x2]             // Guardar arr[end] en arr[start]
    str w5, [x3]             // Guardar arr[start] en arr[end]

    // Incrementar start y decrementar end
    add x2, x2, #4           // Avanzar x2 (start) al siguiente elemento
    sub x3, x3, #4           // Retroceder x3 (end) al elemento anterior
    b reverse_loop           // Repetir el bucle

end_reverse:
    ret                      // Retornar al llamador