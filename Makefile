generate-ssh-keys:
	ssh-keygen -t ed25519 -C "ubuntu@yandex.com" -f ~/.ssh/yandex/id_rsa

yandex-tokens-setup:
	ansible-playbook ansible/yandex-secrets.yml

terraform-apply:
	ansible-playbook ansible/terraform-apply.yml

ssh:
	ssh -F ssh_config bastion
