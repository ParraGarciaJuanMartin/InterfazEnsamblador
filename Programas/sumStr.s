// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: sumStr.s
// Descripción: (Recorrido de arreglos) Suma de elementos en un arreglo
// Versión: 1.2
// ====================================================
// Código en C
//
// int sumArray(int* arr, int size) {
//     int sum = 0;
//     for (int i = 0; i < size; i++) {
//         sum += arr[i];
//     }
//     return sum;
// }
//
// ====================================================

.section .data
array:  .word 5, 10, 15, 20, 25   // Arreglo de enteros
size:   .word 5                   // Tamaño del arreglo

.section .text
.global _start

_start:
    // Cargar la dirección base del arreglo y su tamaño
    ldr x0, =array               // Dirección base del arreglo en x0
    ldr x1, =size                // Dirección del tamaño del arreglo en x1
    ldr w1, [x1]                 // Cargar el tamaño real en w1
    uxtw x1, w1                  // Extender w1 a x1 para usarlo como 64 bits

    // Llamar a sumArray
    bl sumArray                  // Llamar a sumArray
    mov w2, w0                   // Guardar el resultado en w2

    // Salir del programa
    mov x8, #93                  // Código de sistema para salida en Linux
    svc #0                       // Llamada al sistema para terminar el programa

// sumArray(int* arr, int size)
sumArray:
    mov w2, #0                   // Inicializar suma (sum = 0)
    mov x3, #0                   // Inicializar índice (i = 0)

sum_loop:
    cmp x3, x1                   // Comparar i con el tamaño
    bge end_sum                  // Si i >= size, salir del bucle

    // Cargar arr[i] en w4
    ldr w4, [x0, x3, lsl #2]     // Dirección base + i * 4 (cada elemento es de 4 bytes)
    add w2, w2, w4               // sum += arr[i]

    // Incrementar el índice
    add x3, x3, #1               // i++
    b sum_loop                   // Repetir el bucle

end_sum:
    mov w0, w2                   // Guardar la suma en w0 como valor de retorno
    ret                          // Retornar al llamador