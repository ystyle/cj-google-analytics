package analytics

from std import collection.*
from std import json.*
from std import serialization.*
from std import net.*
from std import io.*

var secret:String = ""
var measurement: String = ""
var DEBUG:Bool = false

external func Setkeys(apiSecret:String, apiMeasurement: String) {
    secret = apiSecret
    measurement = apiMeasurement
}

external func Debug(debug: Bool) {
    DEBUG = debug
}

external class Payload <: Serializable<Payload> {
    let ClientID:String
    var UserID:Option<String>
    var TimestampMicros:Option<Int64> = None
    let UserProperties:Option<HashMap<String, String>>  = None
    var NonPersonalizedAds:Option<Bool> = None
    var Events:Buffer<Event>
    init(ClientID!: String, UserID!:String, Events!:Buffer<Event>) {
        this.ClientID = ClientID
        this.UserID = UserID
        this.Events = Events
    }
    init(ClientID!: String, Events!:Buffer<Event>) {
        this.ClientID = ClientID
        this.UserID = None
        this.Events = Events
    }

    func serialize(): DataModel {
        let dms = DataModelStruct()
        dms.add(field<String>("client_id", this.ClientID))
        dms.add(field<Option<String>>("user_id", this.UserID))
        dms.add(field<Option<Int64>>("timestamp_micros", this.TimestampMicros))
        dms.add(field<Option<HashMap<String, String>>>("user_properties", this.UserProperties))
        dms.add(field<Option<Bool>>("non_personalized_ads", this.NonPersonalizedAds))
        dms.add(field<Buffer<Event>>("events", this.Events))
        return dms
    }

    static func deserialize(dm: DataModel): Payload {
        return Payload(ClientID: "", Events: Buffer<Event>())
    }

    func send() {
        let client = Client()
        let body = this.serialize().toJson().toJsonString()
        var url = "https://www.google-analytics.com/mp/collect?api_secret=${secret}&measurement_id=${measurement}"
        if (DEBUG) {
            url = "http://www.google-analytics.com/debug/mp/collect?api_secret=${secret}&measurement_id=${measurement}"
            println("url: ${url}")
            println("body: ${body}")
        }
        let res = client.post(url, "application/json", StringStream(body))
        match (res) {
            case Ok(_) => println("google-analytics: sended.")
            case Err(e) => println("google-analytics: [Err] ${e.getMessage()}")
        }
    }
}

external class Event <: Serializable<Event> {
    var name:String
    var params:HashMap<String, String> = HashMap()
    init(name!:String, params!:HashMap<String, String>) {
        this.name = name
        this.params = params
    }

    func serialize(): DataModel {
        return DataModelStruct().add(field<String>("name", this.name)).add(field<HashMap<String, String>>("params", this.params))
    }

    static func deserialize(dm: DataModel): Event {
        return Event(name:"test", params:HashMap<String, String>())
    }
}