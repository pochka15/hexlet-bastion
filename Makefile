generate-ssh-keys:
	ssh-keygen -t ed25519 -C "ubuntu@yandex.com" -f ~/.ssh/yandex/id_rsa

yandex-tokens-setup:
	ansible-playbook ansible/yandex-token.yml

terraform-setup:
	ansible-playbook ansible/terraform-setup.yml

setup:
	ansible-playbook ansible/setup.yml -i ansible/inventory.ini --ssh-extra-args "-F ssh_config"

release:
	ansible-playbook ansible/release.yml -i ansible/inventory.ini --ssh-extra-args "-F ssh_config"

ssh:
	ssh -F ssh_config bastion
