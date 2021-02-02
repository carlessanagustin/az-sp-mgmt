# manage azure sp via cli

## requirements

* azure cli
* jq

## usage

```shell
cp vars.sh secrets.sh
vim secrets.sh
SP_NAME=test-carles-01 SP_ROLE1="Reader" ./sp_mgmt.sh
```

## improvements

* add: 

```shell
    --create-cert      : Create a self-signed certificate to use for the credential. Only the
                         current OS user has read/write permission to this certificate.
        Use with `--keyvault` to create the certificate in Key Vault. Otherwise, a certificate will
        be created locally.
    --keyvault         : Name or ID of a KeyVault to use for creating or retrieving certificates.
```
