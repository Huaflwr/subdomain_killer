# subdomain_killer

#### 一款SRC子域名挖掘脚本。从子域名扫描发现到漏洞挖掘，一条龙服务。

---

## 这个是什么

### 一键调用subfinder+httpx+nuclei/afrog扫描器

输入主域名-->发现子域名-->探测子域名存活-->扫描子域名漏洞

你需要做的是，只是，

**输入一个目标主域名or包含主域名的文件**



![image-20230331162351812](https://picupload-1305874651.cos.ap-guangzhou.myqcloud.com/picgo/30847d09f673b64d2a9c961596bada7b.png)

---

## 项目背景and使用场景

因为手工挖漏洞太累了，实在需要做一个自动化的小工具。

本脚本可以指定文件，因此可以输入目标域名资产，写一个计划任务，每天跑一次，坐等漏洞入袋即可。

---

## 使用教程

### 下载扫描工具

下面列出相关项目，感谢他们的付出。为了便于维护，本项目不提供这些扫描工具，需要自己先去下载回来，放在脚本同目录即可。

- [subfinder-子域名查找工具,可以自行配置API接口，获取更多更全面的子域名](https://hub.nuaa.cf/projectdiscovery/subfinder)
- [httpx-快速获取域名标题、状态码、响应大小等等信息](https://hub.nuaa.cf/projectdiscovery/httpx)
- [nuclei-基于模板的一款漏洞扫描器](https://hub.nuaa.cf/projectdiscovery/nuclei)

### **输入一个目标主域名or包含主域名的文件**

格式如：-d [domain] 或 -f [DOMAIN_FILE]

举例如：

- ./run.sh -d example.com
- ./run.sh -f example.txt

### 扫描结果

保存在域名同名目录下。
