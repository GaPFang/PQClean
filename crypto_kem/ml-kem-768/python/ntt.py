import numpy as np

twiddles = [[
    "xxxx",  -758,  -359, -1517,  1493,  1422,   287,   202,
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
], [
    "xxxx", -758, -1517, -359, 202, 287, 1422, 1493,
    1468, -1474, -1202, 962, 182, 1577, 622, -171,
    -1571, -205, 411, -1542, 608, 732, 1017, -681,
    -130, -1602, 1458, -829, 383, 264, -1325, 573,
    -1275, 677, -1065, 448, -725, -1508, 961, -398,
    -951, -247, -1421, 107, 830, -271, -90, -853,
    1469, 126, -1162, -1618, -666, -320, -8, 516,
    -1544, -282, 1491, -1293, 1015, -552, 652, 1223,
    1628, 1522, -1460, 958, 991, 996, -308, -108,
    478, -870, -854, -1510, 794, -1278, -1530, -1185,
    -1659, -1187, 220, -874, -1335, 1218, -136, -1215,
    384, -1465, -1285, 1322, 610, 603, 1097, 817,
    -75, -156, 329, 418, 349, -872, 644, -1590,
    1119, -602, 1483, -777, -147, 1159, 778, -246,
    1653, 1574, -460, -291, -235, 177, 587, 422,
    105, 1550, 871, -1251, 843, 555, 430, -1103
]]

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

# def barrett_reduce(a: int) -> int:
#     """Barrett reduction"""
#     t = int16(((1 << 26) + Q // 2) // Q)
#     t = (t * a + (1 << 25)) >> 26
#     t *= Q
#     t = a - t
#     return t

def fqmul(a: int, b: int) -> int:
    """Multiplication followed by Montgomery reduction"""
    return montgomery_reduce(a * b)

def BFU(vec0, vec1, twiddles, intt=False):
    """Perform a basic functional unit operation."""
    for i in range(len(vec0)):
        if not intt:
            t = fqmul(twiddles[i], vec1[i])
            vec1[i] = vec0[i] - t
            vec0[i] = vec0[i] + t
        else:
            u = vec0[i] + vec1[i]
            u = u if u < Q else u - Q
            # vec0[i], vec1[i] = barrett_reduce(vec0[i] + vec1[i]), fqmul(twiddles[i], vec1[i] - vec0[i])
            vec0[i], vec1[i] = u, fqmul(twiddles[i], vec1[i] - vec0[i])

def print_groups(groups):
    """Print the groups of indices."""
    for group in groups:
        for i in group:
            print(f"{i:3d}", end=' ')
        print()
    print()

def permute_ntt(vec0, vec1, intt=False):
    """Permute the vectors for NTT."""
    if intt:
        return
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

def permute_intt(vec0, vec1, intt=False):
    """Permute the vectors for inverse NTT."""
    if not intt:
        return
    new_vec1, new_vec2 = [], []
    for i in range(len(vec0) // 2):
        new_vec1.append(vec0[i * 2])
        new_vec2.append(vec0[i * 2 + 1])
    for i in range(len(vec0) // 2):
        new_vec1.append(vec1[i * 2])
        new_vec2.append(vec1[i * 2 + 1])
    vec0.clear()
    vec1.clear()
    vec0.extend(new_vec1)
    vec1.extend(new_vec2)

def stage(s: int, k: int, banks: list, groups: list, num_bfu: int, intt=False):
    if intt:
        s = 8 - s  # Reverse the stage for inverse NTT
    if s == 1:
        for i in range(len(banks[0])):
            group_indices = [banks[xor_all_bits(i)][i // 2], banks[xor_all_bits(i) ^ 1][i // 2 + 2]]
            # print(group_indices)
            group0 = groups[group_indices[0]]
            group1 = groups[group_indices[1]]
            BFU(group0, group1, [twiddles[intt][k] for _ in range(num_bfu)], intt=intt)
        # print_groups(groups)
    elif s == 2:
        for i in range(len(banks[0])):
            group_indices = [banks[xor_all_bits(i)][i // 2 * 2], banks[xor_all_bits(i) ^ 1][i // 2 * 2 + 1]]
            # print(group_indices)
            group0 = groups[group_indices[0]]
            group1 = groups[group_indices[1]]
            BFU(group0, group1, [twiddles[intt][k + i // 2] for _ in range(num_bfu)], intt=intt)
        # print_groups(groups)
    elif s == 3:
        for i in range(len(banks[0])):
            group_indices = [banks[xor_all_bits(i)][i], banks[xor_all_bits(i) ^ 1][i]]
            # print(group_indices)
            group0 = groups[group_indices[0]]
            group1 = groups[group_indices[1]]
            permute_intt(group0, group1, intt=intt)
            BFU(group0, group1, [twiddles[intt][k + i] for _ in range(num_bfu)], intt=intt)
            permute_ntt(group0, group1, intt=intt)
        # print_groups(groups)
    elif s == 4:
        for i in range(len(banks[0])):
            group_indices = [banks[xor_all_bits(i)][i], banks[xor_all_bits(i) ^ 1][i]]
            # print(group_indices)
            group0 = groups[group_indices[0]]
            group1 = groups[group_indices[1]]
            permute_intt(group0, group1, intt=intt)
            BFU(group0, group1, [twiddles[intt][k + i * 2 + j % 2] for j in range(num_bfu)], intt=intt)
            permute_ntt(group0, group1, intt=intt)
        # print_groups(groups)
    elif s == 5:
        for i in range(len(banks[0])):
            group_indices = [banks[xor_all_bits(i)][i], banks[xor_all_bits(i) ^ 1][i]]
            # print(group_indices)
            group0 = groups[group_indices[0]]
            group1 = groups[group_indices[1]]
            permute_intt(group0, group1, intt=intt)
            BFU(group0, group1, [twiddles[intt][k + i * 4 + j % 4] for j in range(num_bfu)], intt=intt)
            permute_ntt(group0, group1, intt=intt)
        # print_groups(groups)
    elif s == 6:
        for i in range(len(banks[0])):
            group_indices = [banks[xor_all_bits(i)][i], banks[xor_all_bits(i) ^ 1][i]]
            # print(group_indices)
            group0 = groups[group_indices[0]]
            group1 = groups[group_indices[1]]
            permute_intt(group0, group1, intt=intt)
            BFU(group0, group1, [twiddles[intt][k + i * 8 + j % 8] for j in range(num_bfu)], intt=intt)
            permute_ntt(group0, group1, intt=intt)
        # print_groups(groups)
    elif s == 7:
        for i in range(len(banks[0])):
            group_indices = [banks[xor_all_bits(i)][i], banks[xor_all_bits(i) ^ 1][i]]
            # print(group_indices)
            group0 = groups[group_indices[0]]
            group1 = groups[group_indices[1]]
            permute_intt(group0, group1, intt=intt)
            permute_intt(group0, group1, intt=intt)
            BFU(group0, group1, [twiddles[intt][k + i * 16 + j % 16] for j in range(num_bfu)], intt=intt)
            permute_ntt(group0, group1, intt=intt)
            permute_ntt(group0, group1, intt=intt)
        # print_groups(groups)

def ntt(input_data, num_bfu, intt=False):
    banks = [[], []]
    groups = [input_data[i:i + num_bfu] for i in range(0, len(input_data), num_bfu)]
    for i in range(len(groups)):
        xor = xor_all_bits(i)
        banks[xor].append(i)

    k = 64 if intt else 1
    for s in range(1, 8):
        stage(s, k, banks, groups, num_bfu, intt=intt)
        k = k >> 1 if intt else k << 1
    
    if intt:
        f = 1441; # mont^2/128
        for i in range(len(groups)):
            for j in range(len(groups[i])):
                groups[i][j] = fqmul(groups[i][j], f)
    
    input_data.clear()
    for group in groups:
        input_data.extend(group)


def main():
    input_data = [i for i in range(256)]
    ntt(input_data, 32, intt=True)
    ntt(input_data, 32, intt=False)
    print("Final output:")
    for i in range(0, len(input_data), 16):
        print(" ".join(f"{input_data[j]:5d}" for j in range(i, i + 16)), "")

if __name__ == "__main__":
    main()