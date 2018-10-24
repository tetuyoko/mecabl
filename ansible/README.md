## provision
### Install Mecab-bl
~~~
cd ansible
ansible-playbook -vvv -i production site.yml
rails動かすのに必要なpkgだけ入れる
ansible-playbook -vvv  -i production site.yml -t nginx # nginx
ansible-playbook -vvv  -i production site.yml -t logrotate # logrotate
~~~
