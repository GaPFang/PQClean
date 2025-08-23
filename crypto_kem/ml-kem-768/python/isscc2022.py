import numpy as np

twiddles = [
    -1044,  -758,  -359, -1517,  1493,  1422,   287,   202,
    -171,   622,  1577,   182,   962, -1202, -1474,  1468,
    573, -1325,   264,   383,  -829,  1458, -1602,  -130,
    -681,  1017,   732,   608, -1542,   411,  -205, -1571,
    1223,   652,  -552,  1015, -1293,  1491,  -282, -1544,
    516,    -8,  -320,  -666, -1618, -1162,   126,  1469,
    -853,   -90,  -271,   830,   107, -1421,  -247,  -951,
    -398,   961, -1508,  -725,   448, -1065,   677, -1275,
    -1103,   430,   555,   843, -1251,   871,  1550,   105,
    422,   587,   177,  -235,  -291,  -460,  1574,  1653,
    -246,   778,  1159,  -147,  -777,  1483,  -602,  1119,
    -1590,   644,  -872,   349,   418,   329,  -156,   -75,
    817,  1097,   603,   610,  1322, -1285, -1465,   384,
    -1215,  -136,  1218, -1335,  -874,   220, -1187, -1659,
    -1185, -1530, -1278,   794, -1510,  -854,  -870,   478,
    -108,  -308,   996,   991,   958, -1460,  1522,  1628
]

Q = 3329  # Kyber modulus (for reduction)
QINV = -3327  # -inverse of q mod 2^16 (for Montgomery reduction)

def xor_all_bits(n: int) -> int:
    """Return XOR of all bits in integer n (0 or 1)."""
    result = 0
    while n > 0:
        result ^= (n & 1)   # XOR with the least significant bit
        n >>= 1             # Shift right
    return result

def int16(x: int) -> int:
    """Simulate C int16_t"""
    x &= 0xFFFF
    return x - 0x10000 if x & 0x8000 else x

def montgomery_reduce(a: int) -> int:
    """Montgomery reduction"""
    t = int16(a * QINV)
    t = (a - t * Q) >> 16
    return t

def fqmul(a: int, b: int) -> int:
    """Multiplication followed by Montgomery reduction"""
    return montgomery_reduce(a * b)

def BFU(vec0, vec1, twiddles):
    """Perform a basic functional unit operation."""
    for i in range(len(vec0)):
        t = fqmul(twiddles[i], vec1[i])
        vec1[i] = vec0[i] - t
        vec0[i] = vec0[i] + t

def print_groups(groups):
    """Print the groups of indices."""
    for group in groups:
        for i in group:
            print(f"{i:3d}", end=' ')
        print()
    print()

def permute(vec0, vec1):
    new_vec1, new_vec2 = [], []
    for i in range(len(vec0) // 2):
        new_vec1.append(vec0[i])
        new_vec1.append(vec1[i])
        new_vec2.append(vec0[i + len(vec0) // 2])
        new_vec2.append(vec1[i + len(vec1) // 2])
    vec0.clear()
    vec1.clear()
    vec0.extend(new_vec1)
    vec1.extend(new_vec2)

def ntt(input_data, num_bfu):
    banks = [[], []]
    groups = [input_data[i:i + num_bfu] for i in range(0, len(input_data), num_bfu)]
    for i in range(len(groups)):
        xor = xor_all_bits(i)
        banks[xor].append(i)

    # stage 1
    k = 1
    for i in range(len(banks[0])):
        group_indices = [banks[xor_all_bits(i)][i // 2], banks[xor_all_bits(i) ^ 1][i // 2 + 2]]
        # print(group_indices)
        group0 = groups[group_indices[0]]
        group1 = groups[group_indices[1]]
        BFU(group0, group1, [twiddles[k] for _ in range(num_bfu)])
    # print_groups(groups)

    # stage 2
    k *= 2  # k = 2
    for i in range(len(banks[0])):
        group_indices = [banks[xor_all_bits(i)][i // 2 * 2], banks[xor_all_bits(i) ^ 1][i // 2 * 2 + 1]]
        # print(group_indices)
        group0 = groups[group_indices[0]]
        group1 = groups[group_indices[1]]
        BFU(group0, group1, [twiddles[k + i // 2] for _ in range(num_bfu)])
    # print_groups(groups)

    # stage 3
    k *= 2  # k = 4
    for i in range(len(banks[0])):
        group_indices = [banks[xor_all_bits(i)][i], banks[xor_all_bits(i) ^ 1][i]]
        # print(group_indices)
        group0 = groups[group_indices[0]]
        group1 = groups[group_indices[1]]
        BFU(group0, group1, [twiddles[k + i] for _ in range(num_bfu)])
        permute(group0, group1)
    # print_groups(groups)
    
    # stage 4
    k *= 2  # k = 8
    for i in range(len(banks[0])):
        group_indices = [banks[xor_all_bits(i)][i], banks[xor_all_bits(i) ^ 1][i]]
        # print(group_indices)
        group0 = groups[group_indices[0]]
        group1 = groups[group_indices[1]]
        BFU(group0, group1, [twiddles[k + i * 2 + j % 2] for j in range(num_bfu)])
        permute(group0, group1)
    # print_groups(groups)
    
    # stage 5
    k *= 2  # k = 16
    for i in range(len(banks[0])):
        group_indices = [banks[xor_all_bits(i)][i], banks[xor_all_bits(i) ^ 1][i]]
        # print(group_indices)
        group0 = groups[group_indices[0]]
        group1 = groups[group_indices[1]]
        BFU(group0, group1, [twiddles[k + i * 4 + j % 4] for j in range(num_bfu)])
        permute(group0, group1)
    # print_groups(groups)
    
    # stage 6
    k *= 2  # k = 32
    for i in range(len(banks[0])):
        group_indices = [banks[xor_all_bits(i)][i], banks[xor_all_bits(i) ^ 1][i]]
        # print(group_indices)
        group0 = groups[group_indices[0]]
        group1 = groups[group_indices[1]]
        BFU(group0, group1, [twiddles[k + i * 8 + j % 8] for j in range(num_bfu)])
        permute(group0, group1)
    # print_groups(groups)
    
    # stage 7
    k *= 2  # k = 64
    for i in range(len(banks[0])):
        group_indices = [banks[xor_all_bits(i)][i], banks[xor_all_bits(i) ^ 1][i]]
        # print(group_indices)
        group0 = groups[group_indices[0]]
        group1 = groups[group_indices[1]]
        BFU(group0, group1, [twiddles[k + i * 16 + j % 16] for j in range(num_bfu)])
        permute(group0, group1)
        permute(group0, group1)     # stage 8
    # print_groups(groups)
    
    input_data.clear()
    for group in groups:
        input_data.extend(group)


def main():
    input_data = [i for i in range(256)]
    ntt(input_data, 32)
    print("Final output:")
    for i in range(0, len(input_data), 16):
        print(" ".join(f"{input_data[j]:5d}" for j in range(i, i + 16)))

if __name__ == "__main__":
    main()