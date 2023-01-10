#
# bash configuration for kubernetes
#

# Facilitate switching of kubeconfig files
function kc {
    if [ -z "$KUBECONFIG_DIR" ]; then
            echo "Please set the variable \"KUBECONFIG_DIR\" in your environment!"
            return 1
    fi
    kubeconfig_path="$KUBECONFIG_DIR"

    if [ -z "$1" ]; then
        cluster=$(ls "$kubeconfig_path" | fzf)
    else
        _result=$(find "$kubeconfig_path" -type f -name "*$1*" -printf "%f\n")
        if [ -n "$_result" ]; then
            _result_count=$(echo "$_result" | wc -l)
            if [ "$_result_count" -eq "1" ]; then
                cluster="$_result"
            else
                cluster="$(echo "$_result" | fzf)"
            fi
        else
            echo "no kubeconfig found for cluster \"$1\""
            return 1
        fi
    fi
    export KUBECONFIG="$kubeconfig_path/$cluster"
}

# decode secrets rather than printing base64 strings
function __kubectl_get_secret_decoded () {
    if [ "$#" -eq "0" ]; then
        echo "Need args"
        return 1
    else
        _result=$(kubectl get secret -o json $@)
        if [ "$?" -ne "0" ]; then
            return $?
        fi
        echo $_result | tr -d '\n' | jq 'select(.data != null).data | map_values(@base64d)'
        echo $_result | tr -d '\n' | jq 'select(.items[0].data != null).items[0].data | map_values(@base64d)'
        return 0
    fi
}
alias kgsecd="__kubectl_get_secret_decoded"
