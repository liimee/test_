import std/httpclient
from htmlparser import parseHtml
import nimquery
import std/xmltree
import t
import std/times
import strutils

proc genRes(g: XmlNode): Result =
  var res = Result()
  let url = g.querySelector(".fc-item__link").attr("href")

  let client = newHttpClient()
  let con = client.getContent(url)
  let content = parseHtml(con)
  var actualContent = content.querySelector(".article-body-viewer-selector")
  for i in 0 .. (len(actualContent) - 2):
    if(actualContent[i].attr("id") == "sign-in-gate"):
      actualContent.delete(i)

  var pp = actualContent.querySelectorAll(".dcr-1usbar2")
  for i in low(pp) .. high(pp):
    xmltree.clear(pp[i])

  res.content = $(content.querySelector(".dcr-1989ovb")) & $(actualContent)
  res.title = content.querySelector("[data-gu-name=\"headline\"]").innerText
  res.link = url
  res.updated = parse(g.querySelector(".fc-item__timestamp").attr("datetime"), "yyyy-MM-dd'T'HH:mm:ss'+0000'", utc())

  result = res

proc tg*(): Feed =
  let client = newHttpClient()
  let content = client.getContent("https://www.theguardian.com/technology/all")
  let res = parseHtml(content)

  let resu = res.querySelectorAll("section.fc-container.fc-container--tag")

  var results: seq[Result]

  for i in low(resu) .. high(resu):
    let item = resu[i]
    let items = item.querySelectorAll(".fc-container__body>div>ul>li:not(.fc-slice__item--mpu-candidate)")

    for i in low(items) .. high(items):
      if("u-faux-block-link" in items[i].attr("class") == false):
        let p = items[i].querySelectorAll("ul>li")

        for i in low(p) .. high(p):
          results.add(genRes(p[i]))
      
      else:
        results.add(genRes(items[i]))

  result = Feed(title: "The Guardian: Technology",
    link: "https://www.theguardian.com/",
    items: results
  )