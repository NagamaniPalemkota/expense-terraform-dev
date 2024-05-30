#!/bin/bash

dnf install ansible -y  #by default, user data will have sudo access
cd /tmp
git clone https://github.com/NagamaniPalemkota/expense-ansible-roles.git
cd expense-ansible-roles
ansible-playbook main.yaml -e component=backend -e password=ExpenseApp1
ansible-playbook main.yaml -e component=frontend
