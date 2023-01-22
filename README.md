# Hexlet bastion project

This is another drill Hexlet DevOps project

## Setup

- Create an account in the Yandex Cloud. We need it to deploy an application
- Generate ssh keys for the Yandex Cloud `make generate-ssh-keys`
- Set variables in [all.yml](./ansible/group_vars/all.yml)
- Setup yandex tokens: `make yandex-tokens-setup`
- Apply terraform: `make terraform-apply`
- Setup servers to release application `make setup`
- Release applications on servers `make release`

## Connect

Connect to the bastion via ssh `make ssh`
