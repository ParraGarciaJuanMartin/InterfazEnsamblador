// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: bSelec.s
// Descripción: (Algoritmos de ordenamiento) Ordenamiento por selección
// Versión: 1.1
// ====================================================
// Código en C#
//
// void SelectionSort(int[] arr) {
//     int n = arr.Length;
//     for (int i = 0; i < n - 1; i++) {
//         int minIndex = i;
//         for (int j = i + 1; j < n; j++) {
//             if (arr[j] < arr[minIndex]) {
//                 minIndex = j;
//             }
//         }
//         // Intercambiar arr[i] y arr[minIndex]
//         int temp = arr[minIndex];
//         arr[minIndex] = arr[i];
//         arr[i] = temp;
//     }
// }
//
// ====================================================

.section .data
array:      .word 7, 3, 5, 1, 9, 2        // Arreglo desordenado de ejemplo
size:       .word 6                       // Tamaño del arreglo

.section .text
.global _start

_start:
    // Cargar el tamaño del arreglo y la dirección base
    ldr x1, =size             // Cargar el tamaño del arreglo en x1 (64-bit)
    ldr w1, [x1]              // Desreferenciar para obtener el tamaño real (32-bit)
    ldr x2, =array            // Dirección base del arreglo en x2

    mov w8, w1                // Guardar el tamaño en w8 para el ciclo externo (n)
    sub w8, w8, #1            // n - 1 (límite superior del ciclo externo)

outer_loop:
    cbz w8, end               // Si w8 es cero, el arreglo está ordenado

    // Inicializar minIndex = i
    mov w9, w8                // Índice actual i para el ciclo externo
    mov x10, x9               // minIndex = i usando registros de 64 bits para LSL

inner_loop:
    // Configurar el índice j para el ciclo interno
    sub x11, x9, #1           // j = i + 1 usando x11 para que LSL funcione

    cmp x11, #0               // Verificar si el ciclo interno terminó
    ble finish_inner_loop     // Si j >= n, terminamos el ciclo interno

    // Cargar los valores de arr[minIndex] y arr[j]
    mov x3, x2                // Dirección base del arreglo en x3
    add x3, x3, x10, lsl #2   // x3 = &arr[minIndex]
    ldr w5, [x3]              // arr[minIndex] en w5

    mov x4, x2                // Dirección base del arreglo en x4
    add x4, x4, x11, lsl #2   // x4 = &arr[j]
    ldr w6, [x4]              // arr[j] en w6

    // Comparar arr[j] y arr[minIndex]
    cmp w6, w5
    bge skip_update_min       // Si arr[j] >= arr[minIndex], no actualizamos minIndex
    mov x10, x11              // minIndex = j usando x10

skip_update_min:
    subs x11, x11, #1         // Decrementar j para el siguiente elemento
    b inner_loop              // Repetir el ciclo interno

finish_inner_loop:
    // Intercambiar arr[i] con arr[minIndex]
    mov x3, x2                // Dirección base del arreglo en x3
    add x3, x3, x9, lsl #2    // x3 = &arr[i]
    ldr w5, [x3]              // arr[i] en w5

    mov x4, x2                // Dirección base del arreglo en x4
    add x4, x4, x10, lsl #2   // x4 = &arr[minIndex]
    ldr w6, [x4]              // arr[minIndex] en w6

    // Realizar el intercambio
    str w6, [x3]              // arr[i] = arr[minIndex]
    str w5, [x4]              // arr[minIndex] = arr[i]

    // Decrementar el índice externo (i) para el siguiente ciclo
    subs w8, w8, #1
    b outer_loop              // Repetir el ciclo externo

end:
    // Preparar para salir
    mov x8, #93               // Código de sistema para salida en Linux
    svc #0                    // Llamada al sistema para terminar el programa