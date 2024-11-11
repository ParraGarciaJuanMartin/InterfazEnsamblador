// ==================================================== 
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: premo.s
// Descripción: (Saltos condicionales) Verifica si un número es primo
// Versión: 1.0
// ==================================================== 
// Descripción en C# :
// bool EsPrimo(int n) {
//     if (n <= 1) return false;
//     for (int i = 2; i * i <= n; i++) {
//         if (n % i == 0) return false;
//     }
//     return true;
// }
// ----------------------------------------------------

    .global _start
    .global es_primo

    .text

_start:
    mov x0, #29              // Número a verificar (ejemplo: 29)
    bl es_primo              // Llama a la función es_primo

    // Terminar el programa
    mov x8, #93              // syscall: exit
    svc #0                   // Llama al sistema para salir

// Función es_primo
// Entrada: x0 contiene el número a verificar
// Salida: x0 = 0 si no es primo, x0 = 1 si es primo
es_primo:
    cmp x0, #2                // Compara n con 2
    blt no_primo              // Si n < 2, no es primo

    // Iterar desde i=2 hasta sqrt(n)
    mov x1, #2                // Inicializa i = 2
check_division:
    mul x2, x1, x1            // Calcula i * i en x2
    cmp x2, x0                // Compara i*i con n
    bgt end_primo             // Si i*i > n, n es primo

    udiv x2, x0, x1           // Calcula n / i
    msub x2, x2, x1, x0       // Calcula n - (i * (n / i))
    cbz x2, no_primo          // Si n % i == 0, no es primo

    add x1, x1, #1            // Incrementa i en 1
    b check_division          // Repite el ciclo

// Resultado: es primo
end_primo:
    mov x0, #1                // x0 = 1 indica que es primo
    ret

// Resultado: no es primo
no_primo:
    mov x0, #0                // x0 = 0 indica que no es primo
    ret
