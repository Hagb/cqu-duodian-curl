# 重庆大学哆点登陆 curl 脚本

重庆大学校园网哆点登陆脚本，基于 curl 和 (b)ash。

在虎溪校区全部功能正常工作。

老校区登陆功能（`duodian_login`）正常工作且返回正确返回值，注销功能（`duodian_logout`）工作但不返回正确返回值，判断是否登陆（`is_duodian_logined`）不工作。（help wanted）

## 用法

先用 `. ./cqu-duodian-curl.sh` 导入脚本，之后可以调用以下相应函数。

老校区使用请在导入脚本后运行`drcom_url_args="$drcom_url_args_old"`。

以下操作均会把哆点登陆服务器返回的网页保存至 `return_html` 变量（可用于调试、登陆失败时进一步解析失败原因等目的）。

### 登陆
```
用法：duodian-login <用户名> <密码> [1]

其中用户名和密码是校园网密码，第三个参数置为 1 时使用双终端登陆方式

返回值：
    0(真) 登陆成功
    1(假) 登陆失败

会读取的 shell 变量：
    ip    传给验证服务器的 ip 地址，作用不详，建议使用与本设备的重大内网 ip
    mac   传给验证服务器的 mac 地址，验证服务器会记录下此 mac 地址


会写入的 shell 变量：
    return_html  登陆服务器返回的网页内容
    
```

示例：

``` bash
. ./cqu-duodian-curl.sh
ip=$()
duodian_login 201xxxxx password || echo Login failed!
```

双终端登陆示例：

``` bash
. ./cqu-duodian-curl.sh
duodian_login 201xxxxx password 1 || echo Login failed!
```

### 判断登陆状态
```
用法：is_duodian_logined

查询登陆状态（老校区暂不可用）

返回值：
    0(真) 登陆状态
    1(假) 未登陆状态
```

示例：

``` bash
. ./cqu-duodian-curl.sh
if is_duodian_logined
then
    echo 已登陆
else
    echo 未登陆
fi
```

### 注销
```
用法：duodian_logout

查询登陆状态

返回值：
    0(真) 成功注销
    1(假) 未成功注销（可能由于调用前已处于未登陆状态）
该返回值在老校区不正确
```

示例：

```
. ./cqu-duodian-curl.sh
duodian_logout
```

## 其他说明

### 登陆保持

登陆后保持登陆只需保持 IP 地址不变，而无需心跳包或再次登陆（但是我个人的实践还是半分钟检测一次）。

（这里请注意不要频繁重新登陆，否则在 <http://user.cqu.edu.cn> 处的登陆日志会变得很多）

但如果某些原因下线（如被自己别处的登陆挤掉，或者虎溪工作日凌晨断网），则需重新登陆。

### `SSL certificate problem: EE certificate key too weak`

运行时报错：

```
curl: (60) SSL certificate problem: EE certificate key too weak
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
```

这是由于默认安全策略不允许使用学校哆点的证书。不过 OpenWrt 上默认策略无此问题。

导入脚本后可通过将 `drcom_url_args` 变量置为 `10.254.7.4`（虎溪校区）或 `202.202.0.163`（老校区）来改成 http 登陆绕过该问题（但安全性降低了）。

### 双终端

`duodian_login` 第三个参数置为 `1` 的登陆可与另一地址上 drcom 或 `duodian_login` 第三个参数留空的登陆共存。

通过这种办法可以实现一号双拨，经测试能获得双倍网速。

### 登陆安全性

可以使用 https 进行登陆以防止中间人攻击，此时可以通过重大哆点的证书（[www-doctorcom-com.pem](www-doctorcom-com.pem)）进行验证。

如果需要使用明文 http，可以将在导入脚本后 `drcom_url_args` 变量置为 `10.254.7.4`（虎溪校区）或 `202.202.0.163`（老校区）。
