# Ansible Learning Project

This repository contains a simple starter structure for Ansible-based automation.

## Structure
- `inventory/hosts.yml` - inventory definitions
- `playbooks/site.yml` - main playbook
- `roles/common/tasks/main.yml` - example role tasks
- `ansible.cfg` - default Ansible configuration

## Quick Start
1. Install Ansible:
   ```bash
   pip install ansible
   ```
2. Run the playbook:
   ```bash
   ansible-playbook -i inventory/hosts.yml playbooks/site.yml
   ```

## Notes
- The example playbook targets `localhost`.
- Adjust the inventory and role tasks as needed for your environment.
