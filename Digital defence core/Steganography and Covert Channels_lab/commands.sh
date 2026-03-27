#!/bin/bash

echo "=== Lab 6: Steganography and Covert Channels ==="

# Create lab directory
mkdir -p ~/steganography_lab
cd ~/steganography_lab

# Install required libraries
pip3 install Pillow numpy matplotlib --user

echo "=== Creating Test Images ==="
python3 << 'EOF'
from PIL import Image
import numpy as np

width, height = 400, 300
image_array = np.random.randint(0, 256, (height, width, 3), dtype=np.uint8)
test_image = Image.fromarray(image_array, 'RGB')
test_image.save('test_image.png')

solid_image = Image.new('RGB', (400, 300), color='blue')
solid_image.save('blue_image.png')

print("Test images created successfully!")
EOF

echo "=== Creating understanding_lsb.py ==="
cat > understanding_lsb.py << 'EOF'
#!/usr/bin/env python3

def demonstrate_lsb():
    original_pixel = 170
    print(f"Original pixel: {original_pixel} = {format(original_pixel, '08b')}")

    message_bit = 1
    print(f"Message bit to hide: {message_bit}")

    modified_pixel = (original_pixel & 0xFE) | message_bit
    print(f"Modified pixel: {modified_pixel} = {format(modified_pixel, '08b')}")
    print(f"Difference: {abs(original_pixel - modified_pixel)}")

    extracted_bit = modified_pixel & 1
    print(f"Extracted bit: {extracted_bit}")
    print(f"Match: {extracted_bit == message_bit}")

if __name__ == "__main__":
    demonstrate_lsb()
EOF

chmod +x understanding_lsb.py

echo "=== Creating steganography_tool.py ==="
cat > steganography_tool.py << 'EOF'
#!/usr/bin/env python3

from PIL import Image
import numpy as np
import sys

class ImageSteganography:
    def __init__(self):
        self.delimiter = "###END###"

    def text_to_binary(self, text):
        return ''.join(format(ord(c), '08b') for c in text)

    def binary_to_text(self, binary_data):
        chars = [binary_data[i:i+8] for i in range(0, len(binary_data), 8)]
        return ''.join(chr(int(char, 2)) for char in chars)

    def hide_message(self, image_path, message, output_path):
        image = Image.open(image_path).convert('RGB')
        data = np.array(image)

        message += self.delimiter
        binary_message = self.text_to_binary(message)
        flat_data = data.flatten()

        if len(binary_message) > len(flat_data):
            print("Message too long for image")
            return False

        for i in range(len(binary_message)):
            flat_data[i] = (flat_data[i] & 0xFE) | int(binary_message[i])

        new_data = flat_data.reshape(data.shape)
        new_image = Image.fromarray(new_data.astype('uint8'), 'RGB')
        new_image.save(output_path)

        print("Message hidden successfully")
        return True

    def extract_message(self, image_path):
        image = Image.open(image_path).convert('RGB')
        data = np.array(image)
        flat_data = data.flatten()

        binary_data = ''.join(str(pixel & 1) for pixel in flat_data)
        text = self.binary_to_text(binary_data)

        end_index = text.find(self.delimiter)
        if end_index != -1:
            print("Hidden message:", text[:end_index])
        else:
            print("No hidden message found")

def main():
    stego = ImageSteganography()

    if len(sys.argv) < 2:
        print("Usage:")
        print("Hide: python3 steganography_tool.py hide <image> <message> <output>")
        print("Extract: python3 steganography_tool.py extract <image>")
        return

    command = sys.argv[1]

    if command == "hide":
        stego.hide_message(sys.argv[2], sys.argv[3], sys.argv[4])
    elif command == "extract":
        stego.extract_message(sys.argv[2])

if __name__ == "__main__":
    main()
EOF

chmod +x steganography_tool.py

echo "=== Creating capacity_checker.py ==="
cat > capacity_checker.py << 'EOF'
#!/usr/bin/env python3

from PIL import Image
import sys

def calculate_capacity(image_path):
    image = Image.open(image_path)
    width, height = image.size
    total_bits = width * height * 3
    max_chars = total_bits // 8
    print(f"Image capacity: {max_chars} characters")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 capacity_checker.py <image>")
    else:
        calculate_capacity(sys.argv[1])
EOF

chmod +x capacity_checker.py

echo "=== Creating stego_detector.py ==="
cat > stego_detector.py << 'EOF'
#!/usr/bin/env python3

from PIL import Image
import numpy as np
import sys

def chi_square_test(image_path):
    image = Image.open(image_path).convert('RGB')
    data = np.array(image).flatten()
    lsbs = data & 1

    zeros = np.count_nonzero(lsbs == 0)
    ones = np.count_nonzero(lsbs == 1)
    expected = (zeros + ones) / 2

    chi_square = ((zeros - expected) ** 2 / expected) + ((ones - expected) ** 2 / expected)
    print("Chi-square value:", chi_square)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 stego_detector.py <image>")
    else:
        chi_square_test(sys.argv[1])
EOF

chmod +x stego_detector.py

echo "=== Creating batch_analyzer.py ==="
cat > batch_analyzer.py << 'EOF'
#!/usr/bin/env python3

import os
import sys

def analyze_directory(directory):
    images = [f for f in os.listdir(directory) if f.endswith('.png')]
    print("Images found:", images)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 batch_analyzer.py <directory>")
    else:
        analyze_directory(sys.argv[1])
EOF

chmod +x batch_analyzer.py

echo "=== Setup Complete ==="
echo "Run:"
echo "python3 understanding_lsb.py"
echo "python3 steganography_tool.py hide test_image.png 'Secret Message' hidden.png"
echo "python3 steganography_tool.py extract hidden.png"
echo "python3 capacity_checker.py test_image.png"
echo "python3 stego_detector.py hidden.png"
echo "python3 batch_analyzer.py ."
