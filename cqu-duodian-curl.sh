#!/usr/bin/env ash
login_success_text="UID"
logined_text="$(cat login_status_text.txt)"
logout_success_text="Msg=14"
host="10.254.7.4"
drcom_url_args=" --user-agent DrCOM-HttpClient --resolve www.doctorcom.com:443:10.254.7.4 --cacert www-doctorcom-com.pem https://www.doctorcom.com"
drcom_url_args_old=" --user-agent DrCOM-HttpClient --resolve www.doctorcom.com:443:202.202.0.163 --cacert www-doctorcom-com.pem https://www.doctorcom.com"
str_in(){
    case "$2" in
        *"$1"*) return 0 ;;
    esac
    return 1
}

md5() {
    expr substr "$( printf %s "$1" | md5sum )" 1 32
}

urlencode() {
    printf %s "$1" | sed 's:%:%25:g
s: :%20:g
s:<:%3C:g
s:>:%3E:g
s:#:%23:g
s:{:%7B:g
s:}:%7D:g
s:|:%7C:g
s:\\:%5C:g
s:\^:%5E:g
s:~:%7E:g
s:\[:%5B:g
s:\]:%5D:g
s:`:%60:g
s:;:%3B:g
s:/:%2F:g
s:?:%3F:g
s^:^%3A^g
s:@:%40:g
s:=:%3D:g
s:&:%26:g
s:\$:%24:g
s:\!:%21:g
s:\*:%2A:g'
}

duodian_login(){
    local user pass date time form md5_date md5_time va5
    user="$(urlencode "$1")"
    pass="$(urlencode "$2")"
    date="$(date +'%Y-%m-%d %T')"
    time="$(date +%s)"
    form="DDDDD=$user&upass=$pass&m1=$mac&0MKKey=0123456789&ver=2.4.0.201912251.G.L.A&sim_sp=cm&cver1=1&cver2=20000000&sIP=$ip&R6=$3"
    md5_date="$(md5 "$form$date")"
    md5_time="$(md5 "$form${time}drcomd007")"
    va5=1.2.3.4.${md5_date}$(for i in 1 7 21 27; do echo -n $(expr substr $md5_time $i 2) ; done)
    echo curl $common_args $drcom_url_args -H "Date: $date" -H "Time: $time" -H "Uip: va5=$va5" -H $host --data "$form" -H "Host: $host"
    return_html="$(curl $common_args $drcom_url_args -H "Date: $date" -H "Time: $time" -H "Uip: va5=$va5" -H $host --data "$form" -H "Host: $host" )"
    str_in "$login_success_text" "$return_html"
    return $?
}

duodian_logout(){
    return_html="$(curl $common_args $drcom_url_args/F.htm -H "Host: $host" )"
    str_in "$logout_success_text" "$return_html"
    return $?
}

is_duodian_logined(){
    return_html="$(curl $common_args $drcom_url_args -H 'Content-Type: application/x-www-form-urlencoded' -H "Host: $host" )"
    str_in "$logined_text" "$return_html"
    return $?
}
