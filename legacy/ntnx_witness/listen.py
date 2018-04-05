import socket

def receiver():
    port = 162
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.bind(("127.0.0.1", port))

    print "waiting on port:", port
    
    while 1:
        data, addr = s.recvfrom(1024)
        if "siteB" in data:
            print "Site B was defined!"
            site = "siteB"
            return site
        
        elif "siteA" in data:
            print "Site A was defined!"
            site = "siteA"
            return site
