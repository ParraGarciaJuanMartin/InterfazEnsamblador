// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: sidekick.s
// Descripción: (Comparación en arreglos) Encontrar el segundo elemento más grande
// Versión: 1.0
// ====================================================
// Código en C
//
// int findSecondLargest(int* arr, int size) {
//     int max = -2147483648;      // Valor mínimo posible
//     int second_max = -2147483648;
//     for (int i = 0; i < size; i++) {
//         if (arr[i] > max) {
//             second_max = max;
//             max = arr[i];
//         } else if (arr[i] > second_max && arr[i] != max) {
//             second_max = arr[i];
//         }
//     }
//     return second_max;
// }
//
// ====================================================

.section .data
array:  .word 10, 20, 30, 25, 15, 35  // Arreglo de enteros
size:   .word 6                       // Tamaño del arreglo

.section .text
.global _start

_start:
    // Cargar la dirección base del arreglo y su tamaño
    ldr x0, =array               // Dirección base del arreglo en x0
    ldr x1, =size                // Dirección del tamaño del arreglo en x1
    ldr w1, [x1]                 // Cargar el tamaño real en w1

    // Llamar a findSecondLargest
    bl findSecondLargest         // Llamar a la función
    mov w2, w0                   // Guardar el resultado en w2

    // Salir del programa
    mov x8, #93                  // Código de sistema para salida en Linux
    svc #0                       // Llamada al sistema para terminar el programa

// findSecondLargest(int* arr, int size)
findSecondLargest:
    mov w2, #-2147483648         // max = INT_MIN
    mov w3, #-2147483648         // second_max = INT_MIN
    mov x4, #0                   // Índice i = 0

loop:
    cmp x4, x1                   // Comparar i con el tamaño
    bge end_find                 // Si i >= size, salir del bucle

    // Cargar arr[i]
    ldr w5, [x0, x4, lsl #2]     // Cargar arr[i] en w5

    // Comparar con max
    cmp w5, w2                   // arr[i] > max
    ble check_second             // Si no, ir a verificar second_max
    mov w3, w2                   // second_max = max
    mov w2, w5                   // max = arr[i]
    b next                       // Continuar al siguiente elemento

check_second:
    cmp w5, w3                   // arr[i] > second_max
    ble next                     // Si no, continuar al siguiente elemento
    cmp w5, w2                   // arr[i] != max
    beq next                     // Si son iguales, continuar
    mov w3, w5                   // second_max = arr[i]

next:
    add x4, x4, #1               // Incrementar i
    b loop                       // Repetir el bucle

end_find:
    mov w0, w3                   // Guardar second_max en w0 como valor de retorno
    ret                          // Retornar al llamador