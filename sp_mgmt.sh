#!/usr/bin/env bash

[[ -z ${SP_NAME} ]]         && export SP_NAME=test-carles-01
[[ -z ${FILE} ]]            && export FILE=credentials.sec.json
[[ -z ${SP_ROLE_NEW} ]]    && export SP_ROLE_NEW="Reader"
[[ -z ${SP_ROLE_ASSIGN} ]]  && export SP_ROLE_ASSIGN="Monitoring Reader"
source ./secrets.sh


# SP MANAGEMENT
create_sp_client_secret(){
  az ad sp create-for-rbac --name ${SP_NAME} --years 2 \
    --role "${SP_ROLE_NEW}" --scopes /subscriptions/${AZ_SUB_ID} \
    > ${FILE}
}

create_sp_client_certificate(){
  az ad sp create-for-rbac --name ${SP_NAME} --years 2 \
    --create-cert \
    --role "${SP_ROLE_NEW}" --scopes /subscriptions/${AZ_SUB_ID} \
    > ${FILE}
  # TODO: then create pfx - openssl pkcs12 -export -out out.pfx -inkey in.pem -in in.pem
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

# todo
create_sp_scope(){
  az role assignment create --assignee http://${SP_NAME} \
    --role "${SP_ROLE_ASSIGN}" \
    --subscription ${AZ_SUB_ID}
    #--scopes /subscriptions/${AZ_SUB_ID}
}

# LOGIN
az_login_with_sp(){
  az login --service-principal --tenant ${AZ_TENANT} \
    --username http://${SP_NAME} --password `jq -r '.password' ${FILE}`
}



"$@"