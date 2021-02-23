# Service Principals (App registrations)
declare -a SP_NAMES
SP_NAMES=( "test-carles-01" "test-carles-02" )
# Subscriptions: az account list -o tsv | awk ' {print $3}'
declare -a SUBSCRIPTIONS
SUBSCRIPTIONS=( "aaa" "bbb" )

# Roles to assign
export SP_ROLE_NEW="Monitoring Reader"

declare -a SP_ROLE_ASSIGN
SP_ROLE_ASSIGN=( "Reader" )


[[ -z ${FILE} ]]        && export FILE=
[[ -z ${AZ_TENANT} ]]   && export AZ_TENANT=
