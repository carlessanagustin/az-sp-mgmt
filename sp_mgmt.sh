#!/usr/bin/env bash
source ./secrets.sh

# SP MANAGEMENT
#create_sp_client_secret_OFF(){
#  az ad sp create-for-rbac --name ${SP_NAME} --years 2 \
#    --role "${SP_ROLE_NEW}" --scopes /subscriptions/${SUBSCRIPTION} \
#    > ${FILE}
#}

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

# ASSIGN ROLE TO SP
#create_sp_scope_OFF(){
#  az role assignment create --assignee http://${SP_NAME} \
#    --role "${SP_ROLE_ASSIGN}" \
#    --subscription ${SUBSCRIPTION}
#    #--scopes /subscriptions/${SUBSCRIPTION}
#}

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



"$@"