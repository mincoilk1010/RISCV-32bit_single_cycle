#ifndef _ENV_PHYSICAL_SINGLE_CORE_H
#define _ENV_PHYSICAL_SINGLE_CORE_H

#define RVTEST_RV32U
#define RVTEST_RV64U
#define TESTNUM x28

#define RVTEST_CODE_BEGIN \
    .text; \
    .global _start; \
    _start:

#define RVTEST_CODE_END

#define RVTEST_PASS \
    li TESTNUM, 1; \
    li x5, 0x100; \
    sw TESTNUM, 0(x5); \
    1: beq x0, x0, 1b;

#define RVTEST_FAIL \
    li x5, 0x100; \
    sw TESTNUM, 0(x5); \
    1: beq x0, x0, 1b;

#define RVTEST_DATA_BEGIN .data
#define RVTEST_DATA_END

#endif
