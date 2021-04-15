#!/usr/bin/env bash
source ./secrets.sh

create_sp_client_secret(){
  [[ ${DEBUG} == "true" ]] && echo az ad sp create-for-rbac --name http://$1 --years 2 --role "\"AcrPull"\" --scopes /subscriptions/$2
  [[ ${DEBUG} == "false" ]] &&     az ad sp create-for-rbac --name http://$1 --years 2 --role "AcrPull" --scopes /subscriptions/$2 >> ${FILE}
}

create_multiple_sp(){
  for i in "${SP_NAMES[@]}";
  do
    for h in "${SUBSCRIPTIONS[@]}";
    do
    create_sp_client_secret $i $h
    done
  done
}

# TODO: then create pfx - openssl pkcs12 -export -out out.pfx -inkey in.pem -in in.pem
create_sp_client_certificate(){
  az ad sp create-for-rbac --name ${SP_NAME} --years 2 \
    --create-cert \
    --role "${SP_ROLE_NEW}" --scopes /subscriptions/${SUBSCRIPTION} \
    > ${FILE}
}

create_sp_sdk(){
  az ad sp create-for-rbac --name ${SP_NAME} --skip-assignment --sdk-auth \
   > ${FILE}
}

create_sp_simple(){
  az ad sp create-for-rbac --name ${SP_NAME} --years 2 \
    > ${FILE}
}

delete_sp(){
  az ad sp delete --id http://${SP_NAME}
}

# ROLE MANAGEMENT
list_roles(){
  az role definition list
}

create_sp_scope(){
  #--scopes /subscriptions/${SUBSCRIPTION}
  [[ ${DEBUG} == "true" ]] && echo az role assignment create --assignee http://$1 --role "$2" --subscription $3
  [[ ${DEBUG} == "false" ]] &&     az role assignment create --assignee http://$1 --role "$2" --subscription $3   
}

assign_multiple_roles_to_sp(){
  for i in "${SP_NAMES[@]}";
  do
    for h in "${SUBSCRIPTIONS[@]}";
    do
      for j in "${SP_ROLE_ASSIGN[@]}";
      do
        create_sp_scope $i "\"$j"\" $h
      done
    done
  done
}

# LOGIN
az_login_with_sp(){
  az login --service-principal --tenant ${AZ_TENANT} \
    --username http://${SP_NAME} --password `jq -r '.password' ${FILE}`
}



##################################
## API permissions
# https://github.com/hashicorp/terraform-provider-azuread/issues/131

[[ -z ${appId} ]] && export appId=xxx-xxx-xxx

az_api_permissions_list(){
  az ad app permission list --id ${appId}
}

az_api_permissions_grants_list(){
  az ad app permission list-grants --id ${appId}
}

az_api_permissions_add(){
  for i in "${ResourceAccessId[@]}"; do
    az ad app permission add --id ${appId} --api ${resourceAppId} --api-permissions $i
  done
  az ad app permission grant --id ${appId} --api ${resourceAppId} --expires 2
  az ad app permission admin-consent --id ${appId}
}

az_api_permissions_del(){
  for i in "${ResourceAccessId[@]}"; do
    az ad app permission delete --id ${appId} --api ${resourceAppId} --api-permissions $i
  done
}



: '
API / Permissions name:
* Azure Active Directory Graph
  * Application.ReadWrite.All
  * Directory.ReadWrite.All
  * User.Read
'
export resourceAppId=00000002-0000-0000-c000-000000000000
export ResourceAccessId='
78c8a3c8-a07e-4b9e-af1b-b5ccab50a175=Scope
1cda74f2-2616-4834-b122-5cb1b07f8a59=Role
'
#az_api_permissions_add

: '
API / Permissions name:
* Microsoft Graph
  * Application.ReadWrite.All
  * Directory.ReadWrite.All
  * User.Read
'
export resourceAppId=00000003-0000-0000-c000-000000000000
export ResourceAccessId='
e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope
c5366453-9fb0-48a5-a156-24f0c49a4b84=Scope
bdfbf15f-ee85-4955-8675-146e8e5296b5=Scope
'
#az_api_permissions_add





"$@"
