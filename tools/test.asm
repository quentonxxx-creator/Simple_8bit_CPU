// test.asm: 測試 5 級 Pipeline 的迴圈跳躍
LI R1, 3
LI R2, 1

LOOP:
SUB R1, R2
BNE R1, LOOP