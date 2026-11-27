# 7x7 crown on the one-a-side promise, AND/OR, S gates (rep2 encoding: rows 0-6, cols 7-13)
import sys,subprocess
mask=sum(1<<(7*u+v) for u in range(7) for v in range(7) if u!=v)
print(subprocess.run(['python3','scratch/rep2.py','7','7',str(mask),sys.argv[1],sys.argv[2]],capture_output=True,text=True).stdout,flush=True)
