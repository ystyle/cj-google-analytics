package google_analytics

import std.collection.{ArrayList, HashMap}
import encoding.json.*
import serialization.serialization.*
import net.http.*
import net.tls.*
import std.io.*

public class Client {
    var _debug = false
    Client(let secret: String, let measurement: String) {}
    public func debug(debug: Bool) {
        this._debug = debug
    }
    public func send(payload:Payload) {
        var config = TlsClientConfig()
        config.verifyMode = TrustAll
        let client = ClientBuilder().tlsConfig(config).build()
        let body = payload.serialize().toJson().toJsonString()
        var url = "https://www.google-analytics.com/mp/collect?api_secret=${secret}&measurement_id=${measurement}"
        if (this._debug) {
            url = "https://www.google-analytics.com/debug/mp/collect?api_secret=${secret}&measurement_id=${measurement}"
            println("url: ${url}")
            println("body: ${body}")
        }
        let res = client.post(url, body)
        if (!(res.status >= 200 && res.status < 300)) {
            throw Exception("Http Status is: ${res.status}")
        }
        if (!this._debug) {
            println("reponse: ${res.status} ${res.bodySize}")
            var bs = Array<UInt8>(4096, item: 0)
            let length = res.body.read(bs)
            var s = String.fromUtf8(bs[..length])
            println(s)
        }
    }
}

public class Payload <: Serializable<Payload> {
    let ClientID: String
    var UserID: Option<String>
    var TimestampMicros: Option<Int64> = None
    var UserProperties: Option<HashMap<String, String>> = None
    var NonPersonalizedAds: Option<Bool> = None
    var Events: ArrayList<Event>
    public init(ClientID!: String, UserID!: String, Events!: ArrayList<Event>) {
        this.ClientID = ClientID
        this.UserID = UserID
        this.Events = Events
    }
    public init(ClientID!: String, Events!: ArrayList<Event>) {
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
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let client_id = String.deserialize(dms.get("client_id"))
        let user_id = Option<String>.deserialize(dms.get("user_id"))
        let timestamp_micros = Option<Int64>.deserialize(dms.get("timestamp_micros"))
        let user_properties = Option<HashMap<String, String>>.deserialize(dms.get("user_properties"))
        let non_personalized_ads = Option<Bool>.deserialize(dms.get("non_personalized_ads"))
        let events = ArrayList<Event>.deserialize(dms.get("events"))
        let payload = Payload(
            ClientID: client_id,
            Events: events
        )
        payload.UserID = user_id
        payload.TimestampMicros = timestamp_micros
        payload.UserProperties = user_properties
        payload.NonPersonalizedAds = non_personalized_ads
        return payload
    }
}

public class Event <: Serializable<Event> {
    var name: String
    var params: HashMap<String, String> = HashMap()
    public init(name!: String, params!: HashMap<String, String>) {
        this.name = name
        this.params = params
    }

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("name", this.name))
            .add(field<HashMap<String, String>>("params", this.params))
    }

    public static func deserialize(dm: DataModel): Event {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let name = String.deserialize(dms.get("name"))
        let params = HashMap<String, String>.deserialize(dms.get("params"))
        return Event(name: name, params: params)
    }
}
