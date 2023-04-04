package analytics

from std import unittest.*
from std import unittest.testmacro.*

@Test
func TestSend():Unit {
    analytics.Setkeys("goCuBfe-TbqTxVcy7d8IEa", "G-GEP9WQXH3R")
    analytics.Debug(true)

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
    payload.send()
}