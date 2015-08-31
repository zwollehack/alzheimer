package com.cupenya

import java.io.FileOutputStream

import com.cupenya.sqlagent.csv.CSVUnivocityParser
import spray.json._

object AlzheimerQ extends App with DefaultJsonProtocol {
  case class Answer (
    question: String,
    answers: List[String],
    data: List[JsonEntry]
  )

  case class JsonEntry (
    postalCode: String,
    neighbourhood: String,
    age: Int,
    answerString: String,
    answerValue: Int
  )
  implicit val JsonEntryFormat = jsonFormat5(JsonEntry)
  implicit val AnswerFormat = jsonFormat3(Answer)

  val questionConfig = List(
    (1, Map("1" -> 1, "2" -> 2, "3" -> 3, "4" -> 4, "5" -> 5, "6" -> 6, "7" -> 7, "8" -> 8, "9" -> 9, "10" -> 10)),
    (2, Map("Vooruit gegaan" -> 3, "Achteruit gegaan" -> 2, "Gelijk gebleven" -> 1)),
    (3, Map("Zal vooruit gaan" -> 3, "Zal achteruit gaan" -> 2, "Zal gelijk blijven" -> 1))
  )

  val csv = new CSVUnivocityParser("C:\\Users\\Elmar Weber\\Desktop\\BvB 2014_age.csv", separator = ',', skipFirst = true)



  val answers = questionConfig.map { cfg =>
    var removedItems = 0
    val entries = csv
      .filter { row =>
        val answer = row(cfg._1)
        if (! cfg._2.isDefinedAt(answer)) {
          removedItems += 1
          false
        } else {
          true
        }
      }
      .map { row =>
        JsonEntry(
          postalCode = row(csv.headersByIdx("postcode")),
          neighbourhood = row(csv.headersByIdx("buurt")),
          age = row(csv.headersByIdx("Leeftijd")).toInt,
          answerString = row(cfg._1),
          answerValue = cfg._2(row(cfg._1))
        )
      }
      .toList
    println(s"$removedItems removed for ${csv.headers(cfg._1)}")
    Answer(csv.headers(cfg._1), cfg._2.keys.toList, entries)
  }
  val out = new FileOutputStream("answers.json")
  out.write(answers.toJson.toString.getBytes("UTF-8"))
  out.close()


}
