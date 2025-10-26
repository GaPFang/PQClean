import re

# === Config ===
input_file = "../hardware/ntt.sv"
output_file = "../hardware/twiddles.mem"

# Regex to match e.g. twiddles[0][13] = -1202;
pattern = re.compile(r'twiddles\[\d+\]\[\s*\d+\s*\]\s*=\s*(-?\d+);')

values = []

# Extract all values from input file
with open(INPUT_FILE, "r") as f:
    for line in f:
        for match in pattern.finditer(line):
            val = int(match.group(1))
            # Convert signed 32-bit to unsigned (for hex output)
            if val < 0:
                val = (1 << 32) + val
            values.append(val)

# Write all values — 8 per line for compactness
with open(OUTPUT_FILE, "w") as f:
    for i in range(0, len(values), 4):
        group = values[i:i+4]
        f.write(" ".join(f"{v:08X}" for v in group) + "\n")

print(f"✅ Extracted {len(values)} values from {INPUT_FILE}")
