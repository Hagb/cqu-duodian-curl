# 重庆大学哆点登陆 curl 脚本

重庆大学校园网哆点登陆脚本，基于 curl 和 (b)ash。

目前仅在虎溪校区测试过。

## 用法

使用请 `source ./cqu-duodian-curl.sh` 并调用以下相应函数。

### 登陆
```
用法：duodian-login <用户名> <密码> [1]

其中用户名和密码是校园网密码，第三个参数置为 1 时使用双终端登陆方式

返回值：
    0(真) 登陆成功
    1(假) 登陆失败
```

示例：

``` bash
source ./cqu-duodian-curl.sh
duodian_login 201xxxxx password || echo Login failed!
```

双终端登陆示例：

``` bash
source ./cqu-duodian-curl.sh
duodian_login 201xxxxx password 1 || echo Login failed!
```

### 判断登陆状态
```
用法：is_duodian_logined

查询登陆状态

返回值：
    0(真) 登陆状态
    1(假) 未登陆状态
```

示例：

``` bash
source ./cqu-duodian-curl.sh
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
```

示例：

```
source ./cqu-duodian-curl.sh
duodian_logout
```

## 其他说明

### 双终端

`duodian_login` 第三个参数置为 `1` 的登陆可与另一地址上 drcom 或 `duodian_login` 第三个参数留空的登陆共存。

### 登陆安全性

可以使用 https 进行登陆以防止中间人攻击，此时可以通过重大哆点的证书（[www-doctorcom-com.pem](www-doctorcom-com.pem)）进行验证。

如果需要使用明文 http，可以将 `drcom_url_args` 变量置为 `10.254.7.4`。

### 老校区使用

（TODO）

目前未充分测试过。

将 `drcom_url_args` 变量置为老校区内网 dns 服务器解析的 `dr.com` 的 ip 后，可以进行登陆、注销，但返回值可能不正确。

未知双终端登陆在老校区是否有效。
