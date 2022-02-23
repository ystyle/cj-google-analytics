# google-analytics
>Implement Measurement Protocol (Google Analytics 4)

### 使用
- 下载代码并创建cpm项目， google-analytics和需要使用的项目目录平级(否则自行修改依赖的path字段)
```shell
$ cd ~/CodeToCangjie
$ git clone https://gitee.com/HW-PLLab/google-analytics.git
$ mkdir ga-demo
$ cd ga-demo
$ cpm new test demo
```
- 在`ga-demo/module.json`添加`requires`
```json
"requires": {
	"GoogleAnalytics": {
		"organization": "ystyle",
		"version":"1.0.0",
		"path": "../google-analytics"
	  }
}
```
- 导入包
```cj
from GoogleAnalytics import analytics.*
```

### 示例
```go
from GoogleAnalytics import analytics.*

from std import collection.*

func main() {
    analytics.Setkeys("goCuBfe-TbqTxV1y7d8IE1", "G-GEP9W1X43R")
    // analytics.Debug(true)

    let payload = Payload(
        ClientID: "238df050-9472-11ec-bfa7-53c3f68f3dc2",
        Events: Buffer<Event>([
            Event(
                name:"kaf_cli",
                params: HashMap<String, String>([
                    ("os", "Linux"),
                    ("arch", "amd64")
                ])
            )
        ])
    )
    payload.send()
}
```