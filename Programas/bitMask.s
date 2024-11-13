// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 12/Nov/2024
// Programa: bitMask.s
// Descripción: Manipulación de bits - establecer, borrar y alternar bits
// Versión: 1.0
// ====================================================
// Codigo en C# :
// ----------------------------------------------------
// using System;
//
// class BitMaskExample {
//     static void Main() {
//         int value = 0b0000_0001; // 1 en binario
//         
//         // Establecer bit en la posición 3 (0b0000_1000)
//         value |= (1 << 3); 
//         Console.WriteLine("Set bit 3: " + Convert.ToString(value, 2).PadLeft(8, '0'));
//         
//         // Borrar bit en la posición 3 (0b0000_0000)
//         value &= ~(1 << 3); 
//         Console.WriteLine("Clear bit 3: " + Convert.ToString(value, 2).PadLeft(8, '0'));
//
//         // Alternar bit en la posición 0 (cambiar entre 1 y 0)
//         value ^= (1 << 0); 
//         Console.WriteLine("Toggle bit 0: " + Convert.ToString(value, 2).PadLeft(8, '0'));
//     }
// }


.global _start

.section .data
    // Área de datos, se podrían agregar variables aquí si es necesario

.section .text
_start:
    // Inicializar el valor en el registro w0 con 1 (0b0000_0001)
    mov w0, #1                  // w0 = 1

    // Establecer el bit en la posición 3 (0b0000_1000)
    mov w1, #1                  // w1 = 1
    lsl w1, w1, #3              // w1 = w1 << 3 (Desplazamiento a la izquierda 3 posiciones)
    orr w0, w0, w1              // w0 = w0 | w1 (establece bit 3)
   
    // Comando para inspeccionar el valor de w0 en GDB
    nop                         // Punto de parada en GDB para verificar resultado
    // Usar en GDB: p/x $w0  -> Debería mostrar 0x00000008
    
    // Borrar el bit en la posición 3
    mvn w1, w1                  // w1 = ~w1 (NOT en bitmask)
    and w0, w0, w1              // w0 = w0 & ~w1 (borra bit 3)

    // Comando para inspeccionar el valor de w0 en GDB
    nop                         // Punto de parada en GDB para verificar resultado
    // Usar en GDB: p/x $w0  -> Debería mostrar 0x00000000
    
    // Alternar el bit en la posición 0
    eor w0, w0, #1              // w0 = w0 ^ 1 (toggle bit 0)

    // Comando para inspeccionar el valor de w0 en GDB
    nop                         // Punto de parada en GDB para verificar resultado
    // Usar en GDB: p/x $w0  -> Debería mostrar 0x00000001
    
    // Salir
    mov x8, #93                 // syscall número de salida para Linux
    svc #0                      // Realizar la syscall

