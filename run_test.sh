#!/bin/bash
TEST_FILE=$1

if [ -z "$TEST_FILE" ]; then
    echo "Loi: Thieu duong dan file test!"
    echo "Cach dung: ./run_test.sh <path_to_.S>"
    exit 1
fi

echo "=> 0. Dang tu dong tao file luat thi (riscv_test.h)..."
mkdir -p test
cat << 'EOF' > test/riscv_test.h
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
EOF

echo "=> 1. Dang bien dich voi GCC..."
rm -f test.elf 

riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -T test/link.ld -I test -I /home/minh-bui/Desktop/riscv-tests/isa/macros/scalar $TEST_FILE -o test.elf

if [ ! -f "test.elf" ]; then
    echo "[ ERROR ] Bien dich that bai. Hay kiem tra lai!"
    exit 1
fi

echo "=> 2. Dang chia nho ROM và RAM..."
riscv64-unknown-elf-objcopy -O verilog --verilog-data-width=4 -j .text* test.elf src/program.hex
riscv64-unknown-elf-objcopy -O verilog --verilog-data-width=4 -j .data* test.elf src/data.hex
riscv64-unknown-elf-objdump -d test.elf > test_disasm.txt

echo "=> 3. Chay mo phong Icarus Verilog..."
iverilog -o riscv_sim sim/riscv_top_tb.v src/*.v
vvp riscv_sim