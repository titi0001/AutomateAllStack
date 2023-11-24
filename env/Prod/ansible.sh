#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost
  tasks:
  - name: Instalando Python3, virtualenv
    apt:
      pkg:
      - python3
      - virtualenv
      update_cache: yes
    become: yes
  - name: Clone API
    ansible.builtin.git:
      repo: https://github.com/titi0001/api-exanple-python.git
      dest: /home/ubuntu/app
      version: main
      force: yes
  - name: Instalando dependencias com pip (Django e Django rest)
    pip: 
      virtualenv: /home/ubuntu/app/venv
      requirements: /home/ubuntu/app/requirements.txt
  - name: Alterando o hosts do settings
    lineinfile:
      path: /home/ubuntu/app/setup/settings.py
      regexp: "ALLOWED_HOSTS"
      line: "ALLOWED_HOSTS = ['*']"
      backrefs: yes
  - name: configurando o BD
    shell: '. /home/ubuntu/app/venv/bin/activate; python /home/ubuntu/app/manage.py migrate'
    
  - name: carregando os dados BD
    shell: '. /home/ubuntu/app/venv/bin/activate; python /home/ubuntu/app/manage.py loaddata clientes'

  - name: Iniciando Server
    shell: '. /home/ubuntu/app/venv/bin/activate; nohup python /home/ubuntu/app/manage.py runserver 0.0.0.0:8000 &'
EOT
ansible-playbook playbook.yml