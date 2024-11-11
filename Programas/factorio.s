// ==================================================== 
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: factorio.s
// Descripción:(Recursión/bucles) Factorial de un número
// El factorial de 0 es 1, y el de cualquier otro número `n` es `n * factorial(n - 1)`.
// Versión:1.3
// ==================================================== 
// Descripción en C# :
// int Factorial(int n) {
//     if (n <= 1) return 1;
//     return n * Factorial(n - 1);
// }
// ---------------------------------------------------- 
    .global _start
    .global factorial

    .text

_start:
    // Asignar el valor inicial para el factorial, por ejemplo, 5
    mov x0, #5                // Calcula factorial de 5
    bl factorial              // Llama a la función factorial
    
    // Finalizar el programa
    mov x8, #93               // syscall: exit
    svc #0                    // Llama al sistema para salir

factorial:
    cmp x0, #1                 // Compara x0 con 1
    ble end_factorial          // Si x0 <= 1, salta a end_factorial
    stp x29, x30, [sp, #-16]!  // Guarda el frame pointer y el link register
    mov x29, sp                // Actualiza el frame pointer
    
    sub x0, x0, #1             // Decrementa x0 en 1
    bl factorial               // Llama recursivamente a factorial
    ldp x29, x30, [sp], #16    // Restaura el frame pointer y el link register

    mul x0, x0, x1             // Multiplica el resultado de la llamada recursiva
    ret                        // Retorna el valor en x0

end_factorial:
    mov x0, #1                 // Caso base: si x0 <= 1, devuelve 1
    ret                        // Retorna el valor en x0
