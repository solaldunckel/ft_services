adduser -D "$SSH_USER"
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd

ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa;
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa;

/usr/sbin/nginx -g 'daemon off;'
