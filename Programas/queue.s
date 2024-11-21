// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: queue.s
// Descripción: (Estructuras de datos) Implementar una cola usando un arreglo
// Versión: 1.1
// ====================================================
// Código en C:
//
// #define MAX_SIZE 5
//
// int queue[MAX_SIZE];
// int front = -1;
// int rear = -1;
//
// void enqueue(int value) {
//     if ((rear + 1) % MAX_SIZE == front) {
//         printf("Queue overflow\n");
//         return;
//     }
//     if (front == -1) front = 0;
//     rear = (rear + 1) % MAX_SIZE;
//     queue[rear] = value;
// }
//
// int dequeue() {
//     if (front == -1) {
//         printf("Queue underflow\n");
//         return -1;
//     }
//     int value = queue[front];
//     if (front == rear) {
//         front = -1;
//         rear = -1;
//     } else {
//         front = (front + 1) % MAX_SIZE;
//     }
//     return value;
// }
//
// ====================================================


.section .data
queue:  .space 20              // Espacio para 5 enteros (4 bytes cada uno)
front:  .word -1               // Inicialmente, la cola está vacía
rear:   .word -1               // Inicialmente, la cola está vacía
max_size: .word 5              // Tamaño máximo de la cola

.section .text
.global _start

_start:
    // Ejemplo: Realizar enqueue, dequeue
    mov w0, #10               // Valor a insertar
    bl enqueue                // enqueue(10)
    mov w0, #20               // Valor a insertar
    bl enqueue                // enqueue(20)
    bl dequeue                // dequeue()
    mov w1, w0                // Guardar el valor de dequeue en w1
    bl dequeue                // dequeue()
    mov w2, w0                // Guardar el valor de dequeue en w2

    // Salir del programa
    mov x8, #93               // Código de sistema para salida en Linux
    svc #0                    // Llamada al sistema para terminar el programa

// void enqueue(int value)
enqueue:
    ldr x1, =rear             // Dirección de rear en x1
    ldr w2, [x1]              // Cargar el valor actual de rear en w2
    ldr x3, =max_size         // Dirección de max_size en x3
    ldr w3, [x3]              // Cargar max_size en w3

    // Calcular (rear + 1) % max_size
    add w4, w2, #1            // rear + 1
    udiv w5, w4, w3           // División entera: w5 = (rear + 1) / max_size
    msub w4, w5, w3, w4       // Resto: w4 = (rear + 1) % max_size

    ldr x6, =front            // Dirección de front en x6
    ldr w6, [x6]              // Cargar el valor de front en w6
    cmp w4, w6                // Comparar (rear + 1) % max_size con front
    beq enqueue_overflow      // Si son iguales, manejar overflow

    // Si front == -1, inicializamos front a 0
    cmp w6, #-1
    bne enqueue_continue
    mov w6, #0
    str w6, [x6]              // Actualizar front a 0

enqueue_continue:
    str w4, [x1]              // Actualizar rear = (rear + 1) % max_size
    ldr x7, =queue            // Dirección base de la cola en x7
    uxtw x4, w4               // Extender w4 a 64 bits
    lsl x4, x4, #2            // Calcular offset: x4 = x4 << 2
    str w0, [x7, x4]          // Guardar value en queue[rear]
    ret

enqueue_overflow:
    // Manejo de overflow (opcional, aquí solo retorna)
    ret

// int dequeue()
dequeue:
    ldr x1, =front            // Dirección de front en x1
    ldr w2, [x1]              // Cargar el valor actual de front en w2
    cmp w2, #-1               // Comparar front con -1
    beq dequeue_underflow     // Si front es -1, manejar underflow

    ldr x3, =queue            // Dirección base de la cola en x3
    uxtw x2, w2               // Extender w2 a 64 bits
    lsl x4, x2, #2            // Calcular offset: x2 << 2
    ldr w0, [x3, x4]          // Recuperar queue[front] en w0

    ldr x5, =rear             // Dirección de rear en x5
    ldr w6, [x5]              // Cargar el valor de rear en w6
    cmp w2, w6                // Comparar front con rear
    bne dequeue_continue

    // Si front == rear, la cola está vacía después del dequeue
    mov w2, #-1               // front = -1
    str w2, [x1]
    str w2, [x5]              // rear = -1
    ret

dequeue_continue:
    // Calcular (front + 1) % max_size
    add w2, w2, #1            // front + 1
    ldr x3, =max_size
    ldr w3, [x3]
    udiv w4, w2, w3           // División entera: w4 = (front + 1) / max_size
    msub w2, w4, w3, w2       // Resto: w2 = (front + 1) % max_size
    str w2, [x1]              // Actualizar front
    ret

dequeue_underflow:
    // Manejo de underflow (opcional, aquí solo retorna -1)
    mov w0, #-1               // Retornar -1 si la cola está vacía
    ret

