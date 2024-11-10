package google_analytics

import std.collection.{HashMap,ArrayList}
import std.process.CurrentProcess

import std.unittest.*
import std.unittest.testmacro.*

@Test
func TestSend():Unit {
    let apiSecret:String = CurrentProcess.current.environment.get("API_SECRET") ?? ""
    let apiMeasurement:String  = CurrentProcess.current.environment.get("API_MEASUREMENT") ?? ""

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