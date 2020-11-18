#!/usr/bin/env ash
login_success_text="$(cat login_success_text.txt)"
logined_text="$(cat login_status_text.txt)"
logout_success_text="Msg=14"
drcom_url_args="--resolve www.doctorcom.com:443:10.254.7.4 --cacert www-doctorcom-com.pem https://www.doctorcom.com"

str_in(){
    case "$2" in
        *"$1"*) return 0 ;;
    esac
    return 1
}

duodian_login(){
    return_html="$(curl -H "Uip: va5=1.2.3.4." $drcom_url_args --data "0MKKey=0123456789&R6=$3" \
        --data-urlencode "DDDDD=$1" --data-urlencode "upass=$2")"
    str_in "$login_success_text" "$return_html"
    return $?
}

duodian_logout(){
    return_html="$(curl $drcom_url_args/F.htm )"
    str_in "$logout_success_text" "$return_html"
    return $?
}

is_duodian_logined(){
    return_html="$(curl $drcom_url_args)"
    str_in "$logined_text" "$return_html"
    return $?
}
