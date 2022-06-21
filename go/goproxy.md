### 设置代理

```
$ go env -w GOPROXY=https://goproxy.cn,direct
$ go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
$ go env -w GOPROXY=https://proxy.golang.com.cn,direct
```

### 取消代理

```
$ go env -u GOPROXY
```

### 查看GO的配置

```
$ go env GOPROXY
$ go env
//以JSON格式输出
$ go env -json
```

**Bash (Linux or macOS)**

```
# 配置 GOPROXY 环境变量
export GOPROXY=https://proxy.golang.com.cn,direct
# 还可以设置不走 proxy 的私有仓库或组，多个用逗号相隔（可选）
export GOPRIVATE=git.mycompany.com,github.com/my/private
```

**PowerShell (Windows)**

```
# 配置 GOPROXY 环境变量
$env:GOPROXY = "https://proxy.golang.com.cn,direct"
# 还可以设置不走 proxy 的私有仓库或组，多个用逗号相隔（可选）
$env:GOPRIVATE = "git.mycompany.com,github.com/my/private"
```

如果使用的是老版本的 Go（< 1.13）, 建议[升级为最新稳定版本](https://gomirrors.org/)。
