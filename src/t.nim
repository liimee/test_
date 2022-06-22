import std/times

type
  Result* = object
    title*, content*, link*: string
    updated*: DateTime

type
  Feed* = object
    title*, link*: string
    items*: seq[Result]