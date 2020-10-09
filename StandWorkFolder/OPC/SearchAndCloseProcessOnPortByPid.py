import socket
import psutil
import os
import signal

ipAddr = '127.0.0.1'
portNum = 4840

def isOpen(ip,port):
   s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   try:
      s.connect((ip, int(port)))
      s.shutdown(2)
      return True
   except:
      return False

def address_to_pid(ip_address='', ip_port=0):
   '''
   determine pid based on IP and port combo
   leverage psutil library and net_connections method
   return the pid of the listening binary
   '''
   possible_pids = set()
   [x.pid for x in psutil.net_connections() if x.laddr == (
      str(ip_address), ip_port) and x.pid not in possible_pids \
    and possible_pids.add(x.pid)]
   if len(possible_pids) < 1:
      return 'Nothing'
   return possible_pids.pop()


def kill_proc_tree(pid, sig=signal.SIGTERM, include_parent=True,
                   timeout=None, on_terminate=None):
   assert pid != os.getpid(), "won't kill myself"
   parent = psutil.Process(pid)
   children = parent.children(recursive=True)
   if include_parent:
      children.append(parent)
   for p in children:
      p.send_signal(sig)
   gone, alive = psutil.wait_procs(children, timeout=timeout,
                                   callback=on_terminate)
   return (gone, alive)

if isOpen(ipAddr, portNum):
   print('Port busy! Try to close...')
   pid = address_to_pid(ipAddr, portNum)
   kill_proc_tree(pid)
   print(isOpen(ipAddr, portNum))
else:
   print(portNum)
   print('Is open!')


