Array::flatMap = (fn) ->
  Array::concat.apply [], @map(fn)

Array::last = (fn) ->
  if @length is 0 then null else @[@length - 1]

Array::contains = (element) ->
  @indexOf(element) isnt -1

Array::distinct = ->
  u = {}
  a = []
  i = 0
  l = @length
  while i < l
    if u.hasOwnProperty(@[i])
      ++i
      continue
    a.push @[i]
    u[@[i]] = 1
    ++i
  a

# [B](f: (A) ⇒ B): B -> [A] ; Although the types in the arrays aren't strict (:
Array::groupBy = (fn) ->
  Array::reduce.apply(@,
    [(groups, item) ->
      group = fn.apply(@, [item])
      groups[group] ?= []
      groups[group].push(item)
      groups
    , []])


@util =
  str:
    isEmpty: (str) ->
      (not str?) or str is ""