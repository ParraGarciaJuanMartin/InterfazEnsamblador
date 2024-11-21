// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: overflow.s
// Descripción: Detección de desbordamiento en suma de enteros
// Versión: 1.0
// ====================================================
// static bool DetectarDesbordamiento(int a, int b)  
// {
    // Intentamos sumar los dos números y verificar si ocurre un desbordamiento
    // try
    // {
        // Realizamos la suma de a y b
        // int resultado = checked(a + b);  // Usamos 'checked' para detectar desbordamiento

        // Si no ocurre desbordamiento, la operación es exitosa, por lo que retornamos false (sin desbordamiento)
        // return false;
    // }
    // catch (OverflowException)  // Si ocurre un desbordamiento, se captura la excepción
    // {
        // Si ocurre un desbordamiento, retornamos true indicando que se detectó el desbordamiento
        // return true;
    // }
// }
// ====================================================

    .data
num1:       .word 2147483647        // Primer número (INT_MAX)
num2:       .word 1                 // Segundo número
overflow:   .word 0                 // Indicador de desbordamiento (1 = sí, 0 = no)
result:     .word 0                 // Resultado de la suma

    .text
    .global _start

// Punto de entrada principal
_start:
    // Cargar los números a sumar
    ldr x0, =num1                  // Cargar dirección de num1
    ldr w1, [x0]                   // Cargar valor de num1 en w1
    ldr x0, =num2                  // Cargar dirección de num2
    ldr w2, [x0]                   // Cargar valor de num2 en w2

    // Realizar la suma y detectar desbordamiento
    adds w3, w1, w2                // Sumar w1 y w2, resultado en w3, afecta flags
    bvs overflow_detected          // Si ocurre desbordamiento (V=1), saltar

    // Sin desbordamiento
    ldr x0, =overflow              // Dirección del indicador de desbordamiento
    mov w4, #0                     // Desbordamiento = 0
    str w4, [x0]                   // Guardar el indicador
    ldr x0, =result                // Dirección del resultado
    str w3, [x0]                   // Guardar el resultado
    b end                          // Terminar

// Desbordamiento detectado
overflow_detected:
    ldr x0, =overflow              // Dirección del indicador de desbordamiento
    mov w4, #1                     // Desbordamiento = 1
    str w4, [x0]                   // Guardar el indicador
    ldr x0, =result                // Dirección del resultado
    mov w3, #0                     // Resultado inválido en caso de desbordamiento
    str w3, [x0]                   // Guardar resultado inválido

// Fin del programa
end:
    mov x8, #93                    // syscall exit
    mov x0, #0                     // exit code
    svc #0