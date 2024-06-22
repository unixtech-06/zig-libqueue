#include <stdio.h>

#include "queue.h"

int
 main(void)
 {
        struct Queue* queue = queue_init();
        if (!queue) {
                fprintf(stderr, "Failed to initialize queue\n");
                return 1;
        }

        queue_push(queue, 10);
        queue_push(queue, 20);
        queue_push(queue, 30);

        int result = queue_at(queue, 1);
        if (result) {
                printf("queue number 2: %d\n", *result);
        } else {
                printf("Invalid index\n");
        }

        queue_deinit(queue);
        return 0;
}