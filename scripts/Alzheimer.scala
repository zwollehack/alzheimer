package com.cupenya

import java.io.FileOutputStream
import spray.json._
import com.cupenya.sqlagent.csv.CSVUnivocityParser

object Alzheimer extends App with DefaultJsonProtocol {
  case class JsonEntry (
    street: String,
    houseNumber: Option[String],
    postalCode: String,
    neighbourhood: String,
    neighbourhoodCode: String,
    gender: String,
    age: Int,
    lat: Double,
    lng: Double
  )
  implicit val JsonEntryFormat = jsonFormat9(JsonEntry)

  val csv = new CSVUnivocityParser("C:\\Users\\Elmar Weber\\Desktop\\GBA_XY.csv", separator = ',', skipFirst = true)

  val out = new FileOutputStream("entries.json")
  var removedItems = 0
  val jsonEntries = csv
  .filter { row =>
    if (row(csv.headersByIdx("x")) == null) {
      removedItems += 1
      false
    } else {
      true
    }
  }
  .map { row =>
    JsonEntry(
      street = row(csv.headersByIdx("StName")) + row(csv.headersByIdx("StType")),
      houseNumber = Option(row(csv.headersByIdx("AddNum"))),
      postalCode = row(csv.headersByIdx("ARC_Postcode")),
      neighbourhood = row(csv.headersByIdx("Buurtnaam")),
      neighbourhoodCode = row(csv.headersByIdx("Buurtcode")),
      gender = row(csv.headersByIdx("Geslacht")),
      age = row(csv.headersByIdx("Age2")).toInt,
      lat = row(csv.headersByIdx("y")).toDouble,
      lng = row(csv.headersByIdx("x")).toDouble
    )
  }.toList

  out.write(jsonEntries.toJson.toString.getBytes("UTF-8"))
  out.close()


  println(s"$removedItems removed")

}
