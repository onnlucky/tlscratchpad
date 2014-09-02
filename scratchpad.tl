#!/usr/bin/env gtl

_env = Env.current

w = Window.new 400, 800
w.title "tl scratchpad - $(repr(system))"
b = Box.new 0, 0, w.width, w.height
w.add(b)
w.onresize(width, height -> b.width(width); b.height(height))
!(sleep 0.1; w.focus)

Snippet = content -> _Mutable_new {
    inputenv = null
    changed = true
    code = null
    env = Var.new
    editor = Editor(content)
    output = Editor("", readonly=true)
    x = 0, y = 0
    width = 0, height = 0
}

snippets = Array.new
current = Var.new 1
focus = Var.new true
snippets.add(Snippet("print \"hello world!\""))

running = Var.new null
internal_print = ->
    if not $running: return print("ERROR:", args.join(" "))
    $running.output.addLines(args.join(" ").split("\n"))
    return
_env = Env.new(_env.set("print", internal_print))

runsnippet = snippet, n ->
    env = { n == 1 }: _env
          {        }: runsnippet(snippets[n - 1], n - 1)
    insame = env == snippet.inputenv
    snippet.inputenv = env
    if insame and not snippet.changed: return snippet.env.get
    snippet.changed = false
    code = snippet.editor.text
    if insame and snippet.code == code: return snippet.env.get
    snippet.code = code

    snippet.output.clear
    snippet.env.set env
    if not env: return

    catch: e ->
        $running = null
        snippet.output.addLines("error: $(e.toString)".split("\n")) //"
        snippet.output.error = true
        return
    $running = snippet
    res = eval(snippet.env, code)
    $running = null
    if res != null:
        r = repr(res)
        { r == "null"   }: snippet.output.addLines("$res".split("\n"))
        {               }: snippet.output.addLine(r)
    snippet.output.error = false
    //print "EVAL:", snippet.output.text
    return snippet.env.get

runcode = ->
    runsnippet(snippets[$current], $current)

w.onkey(event ->
    catch: e -> print e.toString
    //print "onkey:", repr(event)
    c = event.key
    ctrl = event.modifiers & 2 == 2
    { ctrl and c == 'Q'  }: w.close
    { ctrl and c == 'R'  }:
        runcode()
        if $focus: snippets[$current].changed = true
    { ctrl and c == 13   }:
        lines = snippets[$current].editor.clearaftercaret
        snippets[$current].changed = true
        $current += 1
        snippets.insert($current, Snippet(lines))
    { ctrl and c == 'J'  }:
        if $current == snippets.size: return
        lines = snippets[$current + 1].editor._lines
        snippets.remove($current + 1)
        if lines.size == 1 and lines[1] == "": return
        snippets[$current].editor.addLines(lines)
    { c == 27            }: $focus = false
    { $focus             }: snippets[$current].editor.onkey(event)
    { c == 38            }: $current = max($current - 1, 1)
    { c == 40            }: $current = min($current + 1, snippets.size + 1)
    { c == 13 or c == 32 }:
        if $current > snippets.size: snippets.add(Snippet())
        snippets[$current].editor._x = 1
        snippets[$current].editor._y = 1
        $focus = true
        snippets[$current].changed = true
    { event.input.size == 1 }:
        if $current > snippets.size: snippets.add(Snippet())
        snippets[$current].editor._x = 1
        snippets[$current].editor._y = 1
        $focus = true
        snippets[$current].changed = true
        snippets[$current].editor.onkey(event)
    {                    }: null
    b.redraw
    // debug
    /*
    print "----", b.width, b.height
    snippets.each: snippet, n ->
        print n, "snippet", snippet.y, snippet.height, snippet.editor.text.split("\n")[1]
    */
)

w.onmouse(x, y, buttons, clicks ->
    catch: e -> print e.toString
    snippets.each: snippet, n ->
        if snippet.y - 5 <= y and y <= snippet.y + snippet.height + 5:
            $focus = true
            snippet.changed = true
            $current = n
            snippet.editor.onmouse(x - snippet.x, y - snippet.y, buttons, clicks)
            b.redraw
            return
    last = snippets[-1]
    if y >= last.y + last.height + 5:
        if last.editor.text.trim.size == 0:
            $focus = true
            last.changed = true
            $current = snippets.size
            last.editor.onmouse(x - last.x, y - last.y, buttons, clicks)
            b.redraw
            return
        snippets.add(Snippet())
        $focus = true
        $current = snippets.size
        b.redraw
)

FHEIGHT = 17
FWIDTH = 8
b.ondraw(g ->
    catch: e -> print e.toString
    g.color(0.95,0.95,0.95)
    g.rectangle(0, 0, b.width, b.height)
    g.fill
    y = Var.new 10
    snippets.each: snippet, n ->
        width, height = snippet.editor.size
        height = max(height, FHEIGHT)
        width = max(width, FWIDTH)
        snippet.x = 10
        snippet.y = $y
        snippet.width = width
        snippet.height = height
        g.save
        g.translate(snippet.x, snippet.y)
        snippet.editor.cursor = false
        snippet.editor.x = 10
        snippet.editor.y = $y
        if n == $current:
            g.rectangle(0, 0, width, height)
            g.color 1,1,1
            if $focus: snippet.editor.cursor = true
            (
                catch: e -> g.color 1,0.95,0.95
                parse(snippet.editor.text)
            )
            g.fill
        snippet.editor.render(g)
        g.restore
        $y += height + 5

        width, height = snippet.output.size
        g.save
        g.translate(10, $y)
        if snippet.output.error:
            g.color 1,0.9,0.9
            g.rectangle(0, 0, width, height)
            g.fill
        snippet.output.render(g)
        g.restore
        $y += height + 10

    if $current > snippets.size:
        g.color 1,1,1
        g.rectangle(10, $y, FWIDTH, FHEIGHT)
        g.fill
)
null

