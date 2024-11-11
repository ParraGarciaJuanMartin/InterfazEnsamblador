// ==================================================== 
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: fibo.s
// Descripción: (Recursión) Serie de Fibonacci
// Versión: 1.0
// ==================================================== 
// Descripción en C# :
// int Fibonacci(int n) {
//     if (n <= 1) return n;
//     return Fibonacci(n - 1) + Fibonacci(n - 2);
// }
// ----------------------------------------------------

    .global _start
    .global fibonacci

    .text

_start:
    mov x0, #10               // Calcula Fibonacci de 10
    bl fibonacci              // Llama a la función fibonacci
    
    // Finalizar el programa
    mov x8, #93               // syscall: exit
    svc #0                    // Llama al sistema para salir

fibonacci:
    cmp x0, #1                // Compara n con 1
    ble end_fibonacci         // Si n <= 1, retorna n (caso base)
    
    // Guardar x29, x30 y el valor original de n en la pila
    stp x29, x30, [sp, #-16]! // Guarda el frame pointer y el link register
    mov x29, sp               // Actualiza el frame pointer
    sub x0, x0, #1            // Calcula Fibonacci(n - 1)
    bl fibonacci              // Llama a fibonacci recursivamente
    mov x1, x0                // Guarda el resultado de Fibonacci(n - 1) en x1

    // Restaura x0 y calcula Fibonacci(n - 2)
    ldr x0, [x29, #16]        // Restaura el valor de n desde la pila
    sub x0, x0, #2            // Calcula Fibonacci(n - 2)
    bl fibonacci              // Llama a fibonacci recursivamente
    
    add x0, x0, x1            // Suma Fibonacci(n - 1) + Fibonacci(n - 2)
    
    // Restaura el frame pointer y el link register
    ldp x29, x30, [sp], #16
    ret                       // Retorna el resultado en x0

end_fibonacci:
    ret                       // Si n <= 1, retorna n
