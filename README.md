# docker-dev

NetBeans v8.1.0 and other development tools in a Docker container accessible via [Xpra](http://xpra.org/).

## Usage

The image bases on [reto/x11-xpra](https://github.com/retog/docker-x11-xpra) so consults its documentation or more usage options.


## Usage example

Start a data-only-container for the data

    docker run -v /home/user --name dev-data  busybox /bin/false

Run with

    docker run -p 2222:22 -d --volumes-from dev-data --name dev reto/dev

Copy your ssh public key to the container so that you can login via ssh
    
    docker exec -i dev /bin/bash -c 'cat >> /home/user/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub

And attach to it with
  
    xpra --ssh="ssh -o \"StrictHostKeyChecking no\" -p 2222" attach ssh:user@localhost:100
   
Start netbeans with  

    ssh -p 2222 user@localhost netbeans
    
The same way you start firefox or open a shell (xterm, tilda).

Backup the user data from the data-only-container:

    docker run --volumes-from dev-data -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /home/user

