#!/usr/bin/env python
import os
from sys import argv, exit

def check_args():
    if len(argv) != 2:
        print(f'[!] Usage {argv[0]} <"comment">')
        exit(0)
    else:
        pass

if __name__ == '__main__':

    print("[*] Checking arguments...")
    check_args()
    print("[*] Formatting comments...")
    comment = str(argv[1])

    print("[*] Building command list...")
    commands = [
        "git add --all",
        f"git commit -m {comment}",
        "git push origin master",
    ]
    
    print("[*] Starting command loop...")
    for c in commands:
        print(f"[*] Running {c}...")
        os.system(c)
    print("[*] Push succeeded!\n[!] Exiting...")
