import sys
import re


OPCODES = {
    "ADD": "0000", # 4'h0
    "SUB": "0001", # 4'h1
    "LI":  "0111", # 4'h7 
    "BNE": "1000", # 4'h8
    "BLT": "1011"  # 4'hB
}

REGISTERS = {
    "R0": "0000", "R1": "0001", "R2": "0010", "R3": "0011",
    "R4": "0100", "R5": "0101", "R6": "0110", "R7": "0111"
}

def to_bin(val, bits):
    if val < 0:
        val = (1 << bits) + val
    return format(val, f'0{bits}b')

def assemble(asm_filepath, mem_filepath):
    with open(asm_filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    instructions = []
    labels = {}
    address = 0

    # Pass 1: 建立 Label Table
    for line in lines:
        line = line.split('//')[0].strip()
        if not line: continue
        if line.endswith(':'):
            labels[line[:-1]] = address
        else:
            instructions.append((address, line))
            address += 1

    # Pass 2: 組譯成 16-bit 機器碼
    machine_codes = []
    for addr, inst in instructions:
        parts = re.split(r'[\s,]+', inst)
        op = parts[0].upper()
        rd = REGISTERS[parts[1].upper()]
        
        if op in ["ADD", "SUB"]:
            rs = REGISTERS[parts[2].upper()]
            # R-Type: Opcode(4) + Rd(4) + Rs(4) + Rt(4) -> Rt 設為 0
            machine_codes.append(f"{OPCODES[op]}_{rd}_{rs}_0000")
            
        elif op == "LI":
            imm = int(parts[2])
            # I-Type: Opcode(4) + Rd(4) + Rs(4, 補0) + Imm(4)
            machine_codes.append(f"{OPCODES[op]}_{rd}_0000_{to_bin(imm, 4)}")
            
        elif op in ["BNE", "BLT"]:
            target_label = parts[2]
            if target_label in labels:
                offset = labels[target_label] - (addr + 1)
                if offset < -8 or offset > 7:
                    raise ValueError(f"行號 {addr}: 偏移量超出 4-bit 範圍")
                # B-Type: Opcode(4) + Rd(4) + Rs(4, 補0) + Offset(4)
                machine_codes.append(f"{OPCODES[op]}_{rd}_0000_{to_bin(offset, 4)}")
            else:
                raise ValueError(f"標籤 {target_label} 不存在")

    with open(mem_filepath, 'w', encoding='utf-8') as f:
        for code in machine_codes:
            f.write(code.replace("_", "") + "\n")
            
    print(f"組譯完成！成功輸出 16-bit 機器碼至 {mem_filepath}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python assembler.py <input.asm> <output.mem>")
    else:
        assemble(sys.argv[1], sys.argv[2])