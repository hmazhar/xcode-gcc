import re
from sys import argv

with open (argv[1], 'r') as f:
    content = f.read()
content = re.sub(argv[2], argv[3], content)
with open (argv[1], 'w') as f:
    f.write(content)

