# The simplest/smallest SSH Server
This is a very simple alpine based SSHD server, listening on port 22. It has no fancy stuff. Just SSHD service running in foreground and rsync installed. It allows only key based access, and the user is `user`. Useful as a jump host inside kubernetes clusters, to further connect to your other secure services behind firewall, etc. You can use it for port forwarding, ssh-agent forwarding, etc.

## Security features:
* Login as `user`.  `user` does not have admin rights. 
* The only authentication enabled over ssh is key based authentication. Repeat: Password based authentication is disabled.
* The container expects a ENV variable named "AUTHORIZED_KEYS" containing your SSH public key(s) in it. If this ENV var is found empty, you'd better use a volume to share an authorized_keys file to /home/user/.ssh, otherwise no one will be able to connect

## docker-compose

docker-compose up -d

Now access this container using ssh, port 2222:
```
[jbeeson@kworkhorse alpine-sshd]$ ssh user@172.17.0.2 -p 2222
a85de77b70a1:~# 
```
