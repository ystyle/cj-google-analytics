import analytics.*

from std import collection.*

func main() {
    analytics.Setkeys("goCuBfe-TbqTxVcy7d8IEA", "G-GEP9WQXH3R")
    analytics.Debug(true)

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