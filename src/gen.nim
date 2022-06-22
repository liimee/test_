import std/xmltree
import std/times
import t

proc giveMeTag(n: string, c: string): XmlNode =
  var g = newElement(n)
  g.add(newText(c))

  result = g

proc generate*(f: Feed): string =
  var items = @[
    giveMeTag("title", f.title),
    giveMeTag("updated", now().utc().format("yyyy-MM-dd'T'HH:mm:ss'Z'")),
    giveMeTag("id", f.link),
    giveMeTag("generator", "test")]

  for i in low(f.items) .. high(f.items):
    let item = f.items[i]
    var el = newElement("entry")

    let content = newElement("content:encoded")
    content.add(newCData(item.content))

    el.add(content)
    el.add(giveMeTag("id", item.link))
    el.add(giveMeTag("updated", item.updated.format("yyyy-MM-dd'T'HH:mm:ss'Z'")))
    el.add(giveMeTag("title", item.title))
    el.add(<>link(rel="alternate", href=item.link))

    items.add(el)

  let tree = newXmlTree("feed", items, toXmlAttributes({"xmlns": "http://www.w3.org/2005/Atom"}))

  result = $tree
