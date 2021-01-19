#!/usr/bin/env bash

export SP_NAME=test-carles-01
export FILE=credentials.sec.json
export SP_ROLE1="Reader"
export SP_ROLE2="Monitoring Reader"

source ./secrets.sh


# SP MANAGEMENT
create_sp(){
  az ad sp create-for-rbac --name ${SP_NAME} --years 2 \
    > ${FILE}
}

create_sp_adv(){
  az ad sp create-for-rbac --name ${SP_NAME} --years 2 \
    --role "${SP_ROLE1}" --scopes /subscriptions/${AZ_SUB_ID} \
    > ${FILE}
}

create_sp_sdk(){
  az ad sp create-for-rbac --name ${SP_NAME} --skip-assignment --sdk-auth \
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
    --role "${SP_ROLE2}" \
    --subscription ${AZ_SUB_ID}
    #--scopes /subscriptions/${AZ_SUB_ID}
}

# LOGIN
az_login_with_sp(){
  az login --service-principal --tenant ${AZ_TENANT} \
    --username http://${SP_NAME} --password `jq -r '.password' ${FILE}`
}

