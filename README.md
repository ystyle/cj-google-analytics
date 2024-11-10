# google-analytics
>Implement Measurement Protocol (Google Analytics 4)

### 使用

1. beta channel版本在`cjpm.toml`里添加
```toml
[dependencies]
  google_analytics = { git = "https://github.com/ystyle/cj-google-analytics", branch = "0.53"}
```
2. dev channel版本在`cjpm.toml`里添加
```toml
[dependencies]
  google_analytics = { git = "https://github.com/ystyle/cj-google-analytics", branch = "master"}
``` 

### 示例
```cj
import google_analytics.*
import std.collection.*

func main() {
    let client = Client(apiSecret, apiMeasurement)
    client.debug(true)

    let payload = Payload(
        ClientID: "238df050-9472-11ec-bfa7-53c3f68f3dc2",
        Events: ArrayList<Event>([
            Event(
                name:"cangjie",
                params: HashMap<String, String>([
                    ("os", "Linux"),
                    ("arch", "amd64")
                ])
            )
        ])
    )
    client.send(payload)
}
```