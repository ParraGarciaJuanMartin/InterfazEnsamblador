// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 12/Nov/2024
// Programa: nLogN.s
// Descripción: (Recursión y manejo de memoria) Merge Sort
// Versión: 1.0
// ====================================================
// Código en C#
//
// void MergeSort(int[] arr, int left, int right) {
//     if (left < right) {
//         int mid = (left + right) / 2;
//         MergeSort(arr, left, mid);
//         MergeSort(arr, mid + 1, right);
//         Merge(arr, left, mid, right);
//     }
// }
//
// void Merge(int[] arr, int left, int mid, int right) {
//     // Implementación de la mezcla de dos mitades
// }
//
// ====================================================


.section .data
array:      .word 38, 27, 43, 3, 9, 82, 10 // Arreglo desordenado de ejemplo
size:       .word 7                       // Tamaño del arreglo

.section .text
.global _start

// Función principal de inicio
_start:
    ldr x0, =array              // Cargar la dirección base del arreglo en x0
    ldr x1, =size               // Cargar la dirección del tamaño en x1
    ldr w1, [x1]                // Obtener el tamaño real en w1
    sub w1, w1, #1              // w1 = tamaño - 1 (índice derecho del arreglo)
    mov w2, #0                  // w2 = índice izquierdo (inicialmente 0)

    bl MergeSort                // Llamar a la función MergeSort

    // Salida del programa
    mov x8, #93                 // Código de sistema para salida en Linux
    svc #0                      // Llamada al sistema para terminar el programa

// MergeSort(int *arr, int left, int right)
MergeSort:
    cmp w2, w1                  // Comparar left y right
    bge end_MergeSort           // Si left >= right, terminar la recursión

    // Calcular el índice medio: mid = (left + right) / 2
    add w3, w2, w1              // mid = left + right
    lsr w3, w3, #1              // mid = (left + right) / 2

    // Llamada recursiva: MergeSort(arr, left, mid)
    stp x29, x30, [sp, #-16]!   // Guardar x29 (FP) y x30 (LR) en la pila
    mov x29, sp                 // Actualizar el marco de pila
    str w1, [sp, #-4]!          // Guardar right en la pila
    mov w1, w3                  // Nuevo valor de right para la llamada
    bl MergeSort                // Llamar a MergeSort(arr, left, mid)
    ldr w1, [sp], #4            // Restaurar right desde la pila

    // Llamada recursiva: MergeSort(arr, mid + 1, right)
    add w2, w3, #1              // left = mid + 1 para la segunda llamada recursiva
    bl MergeSort                // Llamar a MergeSort(arr, mid + 1, right)
    ldp x29, x30, [sp], #16     // Restaurar el marco de pila

    // Llamada a la función Merge(arr, left, mid, right)
    mov w1, w2                  // left
    mov w2, w3                  // mid
    mov w3, w1                  // right
    bl Merge                    // Llamar a la función Merge
    b end_MergeSort

end_MergeSort:
    ret

// Merge(int *arr, int left, int mid, int right)
// Función de mezcla para combinar dos mitades ordenadas
Merge:
    // Implementación de la función Merge (mezcla) pendiente
    ret