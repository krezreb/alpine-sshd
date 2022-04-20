# The simplest/smallest SSH Server
This is a very simple alpine based SSHD server, listening on port 22. It has no fancy stuff. Just SSHD service running in foreground and rsync installed. It allows only key based access, and the user is `user`. Useful as a jump host inside kubernetes clusters, to further connect to your other secure services behind firewall, etc. You can use it for port forwarding, ssh-agent forwarding, etc.

## Security features:
* Login as `user`.  `user` does not have admin rights.
* There is a second user called `tunnel_user` who does not have a shell and can only be used to create users
* The only authentication enabled over ssh is key based authentication


## setup

* For the `user` the container expects one or more env variables prefixed "SSH_PUBKEY" with authorized client ssh keys. 
* For the `tunnel_user` the container expects one or more env variables prefixed "TUNNEL_SSH_PUBKEY" with authorized client ssh keys. 

```yaml
services:
    sshd:
        build: .
        ports:
            - "2222:22"
        volumes:
            - server_keys:/server_keys
        environment:
            # these users can log in and run commands
            - SSH_PUBKEY_1: ssh-rsa AAAAB3NzsdfgaN1zw== user@example
            - SSH_PUBKEY_2: ssh-rsa AAAAsdfgsdfgjgh...F6igWaN1zw== user@example
            # this user cannot run commands, only make tunnels
            - TUNNEL_SSH_PUBKEY_1: ssh-rsa AAAAsdfgsdfgjgh...F6igWaN1zw== user@example

```

`docker-compose up -d`

Now access this container using ssh, port 2222:
```
[jbeeson@workhorse alpine-sshd]$ ssh user@172.17.0.2 -p 2222
a85de77b70a1:~# 
```
