// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: stack.s
// Descripción: (Estructuras de datos) Implementar una pila usando un arreglo
// Versión: 1.5
// ====================================================
// Código en C
//
// #define MAX_SIZE 5
//
// int stack[MAX_SIZE];
// int top = -1;
//
// void push(int value) {
//     if (top >= MAX_SIZE - 1) {
//         printf("Stack overflow\n");
//         return;
//     }
//     stack[++top] = value;
// }
//
// int pop() {
//     if (top == -1) {
//         printf("Stack underflow\n");
//         return -1;
//     }
//     return stack[top--];
// }
//
// int peek() {
//     if (top == -1) {
//         printf("Stack is empty\n");
//         return -1;
//     }
//     return stack[top];
// }
//
// ====================================================

.section .data
stack:  .space 20              // Espacio para 5 enteros (4 bytes cada uno)
top:    .word -1               // Inicialmente la pila está vacía
max_size: .word 5              // Tamaño máximo de la pila

.section .text
.global _start

_start:
    // Ejemplo: Realizar push, pop y peek
    mov w0, #10               // Valor a insertar
    bl push                   // push(10)
    mov w0, #20               // Valor a insertar
    bl push                   // push(20)
    bl peek                   // peek()
    mov w1, w0                // Guardar el valor de peek en w1
    bl pop                    // pop()
    mov w2, w0                // Guardar el valor de pop en w2

    // Salir del programa
    mov x8, #93               // Código de sistema para salida en Linux
    svc #0                    // Llamada al sistema para terminar el programa

// void push(int value)
push:
    ldr x1, =top              // Dirección de top en x1
    ldr w2, [x1]              // Cargar el valor actual de top en w2
    ldr x3, =max_size         // Dirección de max_size en x3
    ldr w3, [x3]              // Cargar max_size en w3

    cmp w2, w3                // Comparar top con max_size - 1
    bge push_overflow         // Si la pila está llena, manejar overflow

    add w2, w2, #1            // Incrementar top (top++)
    str w2, [x1]              // Guardar el nuevo valor de top
    ldr x4, =stack            // Dirección base de la pila en x4
    uxth x5, w2               // Extender w2 a x5 como valor de 64 bits
    lsl x5, x5, #2            // Calcular offset: x5 = x5 << 2
    str w0, [x4, x5]          // Guardar value en stack[top]
    ret

push_overflow:
    // Manejo de overflow (opcional, aquí solo retorna)
    ret

// int pop()
pop:
    ldr x1, =top              // Dirección de top en x1
    ldr w2, [x1]              // Cargar el valor actual de top en w2

    cmp w2, #-1               // Comparar top con -1
    ble pop_underflow         // Si la pila está vacía, manejar underflow

    ldr x3, =stack            // Dirección base de la pila en x3
    uxth x5, w2               // Extender w2 a x5 como valor de 64 bits
    lsl x5, x5, #2            // Calcular offset: x5 = x5 << 2
    ldr w0, [x3, x5]          // Recuperar stack[top] en w0
    sub w2, w2, #1            // Decrementar top (top--)
    str w2, [x1]              // Guardar el nuevo valor de top
    ret

pop_underflow:
    // Manejo de underflow (opcional, aquí solo retorna -1)
    mov w0, #-1               // Retornar -1 si la pila está vacía
    ret

// int peek()
peek:
    ldr x1, =top              // Dirección de top en x1
    ldr w2, [x1]              // Cargar el valor actual de top en w2

    cmp w2, #-1               // Comparar top con -1
    ble peek_empty            // Si la pila está vacía, manejar vacío

    ldr x3, =stack            // Dirección base de la pila en x3
    uxth x5, w2               // Extender w2 a x5 como valor de 64 bits
    lsl x5, x5, #2            // Calcular offset: x5 = x5 << 2
    ldr w0, [x3, x5]          // Recuperar stack[top] en w0
    ret

peek_empty:
    // Manejo de pila vacía (opcional, aquí solo retorna -1)
    mov w0, #-1               // Retornar -1 si la pila está vacía
    ret