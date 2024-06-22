#ifndef QUEUE_H
#define QUEUE_H

#include <stddef.h>
#include <stdbool.h>

// Constructor
struct Queue* queue_init(void);

// Destructor
void queue_deinit(struct Queue* queue);

// Element access
int* queue_front(struct Queue* queue);
int queue_front_const(const struct Queue* queue);
int* queue_back(struct Queue* queue);
int queue_back_const(const struct Queue* queue);

// Capacity
bool queue_empty(const struct Queue* queue);
size_t queue_size(const struct Queue* queue);

// Modifiers
bool queue_push(struct Queue* queue, int value);
void queue_pop(struct Queue* queue);
void queue_swap(struct Queue* queue1, struct Queue* queue2);

// Additional functions
int queue_at(const struct Queue* queue, size_t index);

// Comparison functions
bool queue_equal(const struct Queue* queue1, const struct Queue* queue2);
bool queue_less_than(const struct Queue* queue1, const struct Queue* queue2);
bool queue_less_than_or_equal(const struct Queue* queue1, const struct Queue* queue2);
bool queue_greater_than(const struct Queue* queue1, const struct Queue* queue2);
bool queue_greater_than_or_equal(const struct Queue* queue1, const struct Queue* queue2);

#endif // QUEUE_H