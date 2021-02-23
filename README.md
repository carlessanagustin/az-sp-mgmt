# manage azure sp via cli

## requirements

* azure cli
* jq

## usage (TODO)

```shell
./sp_mgmt.sh create_multiple_sp > run.sh
./sp_mgmt.sh assign_multiple_roles_to_sp >> run.sh
chmod +x run.sh
./run.sh
```

## usage (WIP)

1. Setup environment adding variables: `cp vars.sh secrets.sh && vim secrets.sh`
2. New SP assignment (`DEBUG=false` to run): `./sp_mgmt.sh create_multiple_sp`
3. Assign roles to SP (`DEBUG=false` to run): `./sp_mgmt.sh assign_multiple_roles_to_sp`

## Access and identity options for Azure Kubernetes Service (AKS)

### AKS custom role

* **IMPORTANT**: To create custom roles, your organization needs Azure AD Premium P1 or P2.
* https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/aks/concepts-identity.md#aks-service-permissions

### Azure built-in roles

* "Storage Account Contributor" = Microsoft.Storage
* "Network Contributor" = Microsoft.Network
* "Virtual Machine Contributor" = Microsoft.Compute
* "AcrPull" = Microsoft.ContainerRegistry
* "Log Analytics Contributor" = Microsoft.OperationalInsights + Microsoft.OperationsManagement




---

## improvements

* add: 

```shell
    --create-cert      : Create a self-signed certificate to use for the credential. Only the
                         current OS user has read/write permission to this certificate.
        Use with `--keyvault` to create the certificate in Key Vault. Otherwise, a certificate will
        be created locally.
    --keyvault         : Name or ID of a KeyVault to use for creating or retrieving certificates.
```
