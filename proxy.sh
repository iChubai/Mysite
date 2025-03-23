# 1. 查找Windows主机的IP地址（WSL2专用）                        
export host_ip=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

# 2. 设置临时代理（端口根据实际代理软件修改，Clash默认7890）
export http_proxy="http://$host_ip:7890"
export https_proxy="http://$host_ip:7890"

# 3. 永久生效配置（添加到~/.bashrc或~/.zshrc）
echo "export host_ip=\$(cat /etc/resolv.conf | grep nameserver | awk '{print \$2}')" >> ~/.bashrc
echo "export http_proxy=\"http://\$host_ip:7890\"" >> ~/.bashrc
echo "export https_proxy=\"http://\$host_ip:7890\"" >> ~/.bashrc

# 4. 配置git代理
git config --global http.proxy http://$host_ip:7890 