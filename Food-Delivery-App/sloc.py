import os
import re

src_dir = r"d:\Food delivery app\src"
extensions = ['.java', '.jsp', '.sql', '.xml']

def count_sloc(file_path):
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()

    sloc = 0
    in_block_comment_java = False
    in_block_comment_xml = False

    for line in lines:
        line = line.strip()
        if not line:
            continue

        # Check if we are inside a block comment
        if in_block_comment_java:
            if '*/' in line:
                in_block_comment_java = False
                line = line.split('*/', 1)[1].strip()
                if not line: continue
            else:
                continue

        if in_block_comment_xml:
            if '-->' in line:
                in_block_comment_xml = False
                line = line.split('-->', 1)[1].strip()
                if not line: continue
            elif '--%>' in line:
                in_block_comment_xml = False
                line = line.split('--%>', 1)[1].strip()
                if not line: continue
            else:
                continue

        # Check for start of block comments
        while '/*' in line:
            if '*/' in line:
                line = re.sub(r'/\*.*?\*/', '', line).strip()
            else:
                in_block_comment_java = True
                line = line.split('/*', 1)[0].strip()
                break
                
        while '<!--' in line or '<%--' in line:
            if '<!--' in line and '-->' in line:
                line = re.sub(r'<!--.*?-->', '', line).strip()
            elif '<%--' in line and '--%>' in line:
                line = re.sub(r'<%--.*?--%>', '', line).strip()
            elif '<!--' in line:
                in_block_comment_xml = True
                line = line.split('<!--', 1)[0].strip()
                break
            elif '<%--' in line:
                in_block_comment_xml = True
                line = line.split('<%--', 1)[0].strip()
                break

        if not line:
            continue

        # Single line comments
        if line.startswith('//') or line.startswith('--'):
            continue

        sloc += 1

    return sloc

results = {ext: {'files': 0, 'sloc': 0} for ext in extensions}
total_sloc = 0
total_files = 0

for root, _, files in os.walk(src_dir):
    for file in files:
        ext = os.path.splitext(file)[1].lower()
        if ext in extensions:
            path = os.path.join(root, file)
            sloc = count_sloc(path)
            results[ext]['files'] += 1
            results[ext]['sloc'] += sloc
            total_sloc += sloc
            total_files += 1

print(f"{'Type':<10} | {'Files':<6} | {'SLOC':<6}")
print("-" * 30)
for ext, data in sorted(results.items(), key=lambda x: x[1]['sloc'], reverse=True):
    if data['files'] > 0:
        print(f"{ext:<10} | {data['files']:<6} | {data['sloc']:<6}")
print("-" * 30)
print(f"{'Total':<10} | {total_files:<6} | {total_sloc:<6}")
