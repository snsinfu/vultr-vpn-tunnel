# VPN tunnel on Vultr Cloud

## Configuration

Store Ansible Vault password:

```
openssl rand -hex 32 > .vaultpass
```


Set these environment variables:

```
vultr_api_key
aws_default_region
aws_access_key_id
aws_secret_access_key
```

Set configuration variables in `config/20-secrets.yml`. Create your own file:

```
rm config/20-secrets.yml
ansible-vault create config/20-secrets.yml
```

The content:

```
infra:
  terraform_s3_bucket: ... # your s3 bucket to save terraform state

admin_password: ... # admin user's password
admin_password_salt: ... # random salt string for password hashing
admin_pubkeys:
  - ssh-ed25519 AAAAC3Nza... # Admin user's SSH pubkey
  - ... # Another pubkey
  - ... # Yet another pubkey

wireguard_port: 12345        # Port that wireguard listens on
wireguard_subnet: x.x.x.x/24 # VPN subnet
wireguard_private_key: ...   # Wireguard server's private key
wireguard_public_key: ...    # Corresponding pubkey

wireguard_clients:
  - name: site-1
    node_id: 10 # Last part of this node's IP address in the VPN subnet
    private_key: ... # (optional) Node's private key
    public_key: ... # Node's public key
    routes:
      # (optional) List of networks that this node routes
      - 192.168.100.0/24
      - 192.168.200.0/24

  - name: laptop-1
    node_id: 101
    public_key: ...

  - name: laptop-2
    node_id: 102
    public_key: ...
```

## Usage

Deploy:

```
make
```

Destroy and clean artifacts:

```
make destroy clean
```
