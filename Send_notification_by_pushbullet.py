import sys
import ntfy.backends.pushbullet
access_token='o.kBuujGSI0RrWFG5ARXTiLcuni8BLK62K'

args = sys.argv
print(args[0])
print(args[1])

ntfy.backends.pushbullet.notify('test', args[1], access_token)