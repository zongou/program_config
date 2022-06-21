source_url=https://github.com/Xhofe/alist
branch=v2.4.3

setup_deps(){
    pkg i golang git -y
    go env -w GOPROXY=https://goproxy.cn,direct
}

clone_source(){
    git clone $source_url -b $branch
}

get_dist(){
    # download alist-web
    https://github.com/alist-org/alist-web/releases
    sed --
}

build(){
    cd ~/alist
    appName="alist"
    builtAt="$(date +'%F %T %z')"
    goVersion=$(go version | sed 's/go version //')
    gitAuthor=$(git show -s --format='format:%aN <%ae>' HEAD)
    gitCommit=$(git log --pretty=format:"%h" -1)
    gitTag=$(git describe --long --tags --dirty --always)
    ldflags="\
-w -s \
-X 'github.com/Xhofe/alist/conf.BuiltAt=$builtAt' \
-X 'github.com/Xhofe/alist/conf.GoVersion=$goVersion' \
-X 'github.com/Xhofe/alist/conf.GitAuthor=$gitAuthor' \
-X 'github.com/Xhofe/alist/conf.GitCommit=$gitCommit' \
-X 'github.com/Xhofe/alist/conf.GitTag=$gitTag' \
"
    go build -ldflags="$ldflags" alist.go

}

compress(){
    tar -czf alist-${branch}-andorid-arm64.tgz alist
}
setup_deps
build
compress
