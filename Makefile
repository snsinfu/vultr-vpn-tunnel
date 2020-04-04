ARTIFACTS = \
  $(CHECKPOINTS) \
  $(GENERATED_FILES)

CHECKPOINTS = \
  _terraform_init.ok \
  _terraform_apply.ok \
  _provision.ok

GENERATED_FILES = \
  terraform/terraform.tfvars \
  ansible/inventory/_10-terraform


.PHONY: all clean destroy ssh

all: _connection.ok
	@:

clean:
	rm -f $(ARTIFACTS)

destroy: terraform/terraform.tfvars
	cd terraform; terraform destroy -auto-approve
	@rm -f _terraform_apply.ok

ssh: _connection.ok
	ssh -F ssh_config $$(scripts/ansible-render tunnel "{{ ansible_user }}@{{ ansible_host }}")

_terraform_init.ok:
	cd terraform; terraform init
	@touch $@

_terraform_apply.ok: _terraform_init.ok terraform/terraform.tfvars
	cd terraform; terraform apply -auto-approve
	@touch $@

terraform/terraform.tfvars: terraform/terraform.tfvars.j2
	scripts/ansible-template $< $@

ansible/inventory/_10-terraform: _terraform_apply.ok
	{ cd terraform; terraform output inventory; } > $@

_connection.ok: ansible/inventory/_10-terraform
	ansible -m ping all
	@touch $@
