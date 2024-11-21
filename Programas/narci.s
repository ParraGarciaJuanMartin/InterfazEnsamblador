// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: narci.s
// Descripción: Verificar si un número es Armstrong
// Versión: 1.1
// ====================================================
// static bool EsNumeroArmstrong(int numero)  
// {
    // int cantidadDigitos = numero.ToString().Length;  // Contamos la cantidad de dígitos del número convirtiéndolo en string y usando su propiedad Length
    // int suma = 0;  // Inicializamos la suma en 0

    // int numeroTemporal = numero;  // Hacemos una copia del número original para poder ir procesando los dígitos

    // while (numeroTemporal > 0)  // Mientras el número temporal sea mayor que 0, seguimos extrayendo los dígitos
    // {
        // int digito = numeroTemporal % 10;  // Obtenemos el último dígito usando el operador módulo (%) con 10

        // suma += (int)Math.Pow(digito, cantidadDigitos);  // Elevamos el dígito a la potencia correspondiente (cantidad de dígitos) y lo sumamos a la variable suma

        // numeroTemporal /= 10;  // Eliminamos el último dígito dividiendo el número temporal por 10 (entero)
    // }

    // return suma == numero;  // Comprobamos si la suma es igual al número original, si es así, es un número de Armstrong
// }
//====================================================
    .data
number:     .word 153               // Número a verificar
result:     .word 0                 // Resultado (1 si es Armstrong, 0 si no)
temp:       .word 0                 // Almacenamiento temporal
sum:        .word 0                 // Suma de los dígitos elevados
digit:      .word 0                 // Dígito actual
power:      .word 3                 // Potencia (número de dígitos)

    .text
    .global _start

// Función principal
_start:
    ldr x0, =number                // Dirección del número
    ldr w1, [x0]                   // w1 = número original
    mov x2, x1                     // Copia del número para extracción

    mov x4, #0                     // Suma acumulada en x4

// Ciclo para extraer dígitos y calcular suma
extract_digit:
    mov w3, #10
    udiv w5, w2, w3                // División entera: w5 = w2 / 10
    msub w6, w5, w3, w2            // Resto: w6 = w2 - (w5 * 10)

    mov w7, w6                     // Base (dígito)
    ldr x8, =power                 // Dirección de potencia
    ldr w8, [x8]                   // w8 = potencia (3)
    bl power_function              // Llama a la función de potencia
    add x4, x4, x0                 // Acumula resultado en x4

    mov x2, x5                     // Actualizar número restante
    cbnz x5, extract_digit         // Si hay más dígitos, repetir

    cmp x4, x1                     // Comparar suma con el número original
    b.eq is_armstrong              // Si iguales, es Armstrong
    b not_armstrong                // Si no, no es Armstrong

// Resultado: Es Armstrong
is_armstrong:
    ldr x0, =result
    mov w1, #1
    str w1, [x0]
    b end

// Resultado: No es Armstrong
not_armstrong:
    ldr x0, =result
    mov w1, #0
    str w1, [x0]
    b end

// Función para calcular la potencia: base^exp
power_function:
    mov x9, x7                    // Base (64 bits)
    mov x10, x8                   // Exponente (64 bits)
    mov x11, #1                   // Resultado inicial (1)
power_loop:
    mul x11, x11, x9              // Multiplica base
    sub x10, x10, #1              // Reducir exponente
    cbnz x10, power_loop          // Si exponente > 0, continuar
    mov x0, x11                   // Retorna resultado en x0
    ret

// Fin del programa
end:
    mov x8, #93                   // syscall exit
    mov x0, #0                    // exit code
    svc #0