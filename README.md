# manage azure sp via cli

## requirements

* azure cli
* jq

## usage

1. Setup environment: `cp vars.sh secrets.sh && vim secrets.sh`
2. New SP assignment: `SP_NAME=test-carles-01 SP_ROLE_NEW="Reader" ./sp_mgmt.sh create_sp_client_secret`
3. Add assignment to SP `SP_NAME=test-carles-01 SP_ROLE_ASSIGN="Monitoring Reader" ./sp_mgmt.sh create_sp_client_secret`

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
