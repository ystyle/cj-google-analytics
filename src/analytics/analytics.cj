package analytics

from std import collection.*
from encoding import json.*
from serialization import serialization.*
from net import http.*
from net import tls.*
from std import io.*

var secret:String = ""
var measurement: String = ""
var DEBUG:Bool = false

public func Setkeys(apiSecret:String, apiMeasurement: String) {
    secret = apiSecret
    measurement = apiMeasurement
}

public func Debug(debug: Bool) {
    DEBUG = debug
}

public class Payload <: Serializable<Payload> {
    let ClientID:String
    var UserID:Option<String>
    var TimestampMicros:Option<Int64> = None
    let UserProperties:Option<HashMap<String, String>>  = None
    var NonPersonalizedAds:Option<Bool> = None
    var Events:ArrayList<Event>
    public init(ClientID!: String, UserID!:String, Events!:ArrayList<Event>) {
        this.ClientID = ClientID
        this.UserID = UserID
        this.Events = Events
    }
    public init(ClientID!: String, Events!:ArrayList<Event>) {
        this.ClientID = ClientID
        this.UserID = None
        this.Events = Events
    }

    public func serialize(): DataModel {
        let dms = DataModelStruct()
        dms.add(field<String>("client_id", this.ClientID))
        dms.add(field<Option<String>>("user_id", this.UserID))
        dms.add(field<Option<Int64>>("timestamp_micros", this.TimestampMicros))
        dms.add(field<Option<HashMap<String, String>>>("user_properties", this.UserProperties))
        dms.add(field<Option<Bool>>("non_personalized_ads", this.NonPersonalizedAds))
        dms.add(field<ArrayList<Event>>("events", this.Events))
        return dms
    }

    public static func deserialize(dm: DataModel): Payload {
        return Payload(ClientID: "", Events: ArrayList<Event>())
    }

    public func send() {
        var tlscfg = TlsClientConfig("/etc/ssl/certs/ca-certificates.crt")
        tlscfg.verifyMode = TlsClientVerifyMode.VerifyNone
        let client = Client(tlscfg)
        let body = this.serialize().toJson()
        var url = "https://www.google-analytics.com/mp/collect?api_secret=${secret}&measurement_id=${measurement}"
        if (DEBUG) {
            url = "https://www.google-analytics.com/debug/mp/collect?api_secret=${secret}&measurement_id=${measurement}"
            println("url: ${url}")
            println("body: ${body.toJsonString()}")
        }
        let res = client.postJson(url, body)
        if (!(res.statusCode >= 200 && res.statusCode < 300)) {
            throw Exception("Http Status is: ${res.statusCode}")
        }
        if (DEBUG) {
            var s = String.fromUtf8(res.readToEnd())
            println(s)
        }
    }
}

public class Event <: Serializable<Event> {
    var name:String
    var params:HashMap<String, String> = HashMap()
    public init(name!:String, params!:HashMap<String, String>) {
        this.name = name
        this.params = params
    }

    public func serialize(): DataModel {
        return DataModelStruct().add(field<String>("name", this.name)).add(field<HashMap<String, String>>("params", this.params))
    }

    public static func deserialize(dm: DataModel): Event {
        return Event(name:"test", params:HashMap<String, String>())
    }
}