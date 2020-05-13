//
//  cpu.h
//  Flynn
//
//  Created by Rocco Bowling on 5/12/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//
// Note: This code is derivative of the Pony runtime; see README.md for more details

#ifndef sched_cpu_h
#define sched_cpu_h

#include "scheduler.h"
#include <stdint.h>
#include <stdbool.h>

void ponyint_cpu_init(void);

uint32_t ponyint_cpu_count(void);

void ponyint_cpu_sleep(int ns);

void ponyint_cpu_relax(void);

uint64_t ponyint_cpu_tick(void);

#endif
