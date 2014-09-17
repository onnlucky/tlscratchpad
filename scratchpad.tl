#!/usr/bin/env gtl

_env = Env.current

w = Window.new 400, 800
b = Box.new 0, 0, w.width, w.height
w.add(b)
w.onresize(width, height -> b.width(width); b.height(height))
!(sleep 0.1; w.focus)
w.title "tl scratchpad - $(repr(system))"

app = widget.App(w, b)
view = widget.Vertical()
app.setView(view)

w.onkey(event ->
    catch: e -> print e.toString
    app.onkey(event)
)
w.onmouse(x, y, buttons, clicks ->
    catch: e -> print e.toString
    view.onmouse({{x,y,buttons,clicks}}, x, y)
)
w.onmousescroll(dx, dy ->
    catch: e -> print e.toString
    view.onmousescroll(dx, dy)
)
b.ondraw(g ->
    catch: e -> print e.toString
    view.size(g, b.width, b.height)
    view.draw(g, b.width, b.height)
)

view.add(widget.Space(10))
editor = Editor("print \"hello world!\"")
view.add(editor)
editor.setFocus
view.add(widget.Space(10))
output = Editor("", readonly=true)
view.add(output)

internal_print = ->
    output.addLines(args.join(" ").split("\n"))
    return
_env = Env.new(_env.set("print", internal_print))

reline = Regex("(line|at:) ([0-9]+)")
runchange = ->
    catch: e ->
        msg = try(e.msg, e) or "unknown"
        line = try(Number(reline.match(msg)[2]))
        editor.setErrorLine(line, msg)
        output.setErrorLine(output.lines + 1)
        output.addLines(try(e.toString, "$msg").split("\n"))
        b.redraw
    code = editor.text
    editor.setErrorLine(null)
    output.setErrorLine(null)
    output.clear
    res = code.eval(_env)
    if res != null:
        r = repr(res)
        { r == "null"   }: output.addLines("$res".split("\n"))
        {               }: output.addLine(r)
    b.redraw

dochange = Var.new 0
editor.onchange = ->
    $dochange += 1
    !(
        sleep 0.2
        x = ($dochange -= 1)
        if x > 0: return
        runchange()
    )
runchange()

