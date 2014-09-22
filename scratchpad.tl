#!/usr/bin/env gtl

_env = Env.current
BYTECODE=false

w = Window.new 400, 800
w.title "tl scratchpad - $(repr(system))"
b = Box.new 0, 0, w.width, w.height
w.add(b)
w.onresize(width, height -> b.width(width); b.height(height))
!(sleep 0.1; w.focus)

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
editor = view.add(Editor("print \"hello world!\""))
editor.setFocus
view.add(widget.Space(5))
control = view.add(RunControl())
view.add(widget.Space(5))
output = view.add(Editor("", readonly=true))
input = view.add(Editor("", singleline=true))
input.setVisible(false)

internal_read = ->
    if control.autorun: Error("autorunning").throw
    if control.task != Task.current: Error("task outdated").throw

    q = Queue.new
    input.onsubmit = ->
        input.setVisible(false)
        q.add input.text
    !(
        input.clear
        input.setVisible(true)
        input.setFocus
        //input.flash
    )
    return q.get

internal_print = ->
    if control.task != Task.current: return
    output.addLines(args.join(" ").split("\n"))
    b.redraw
    return
_env = Env.new(_env.set("print", internal_print).set("read", internal_read))


reline = Regex("(line|at:) ([0-9]+)")
stop = ->
    task = control.task
    control.task = null
    input.setVisible(false)
    if task: task.abort()

start = ->
    task = Task.new(bool(control.autorun, 2000, null))
    catch: e ->
        if control.task != task: return
        control.task = null
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
    control.task = task
    { BYTECODE }:
        mod = compiler.load(code, _env)
        mod.run([], task)
    {          }:
        task.run(->code.eval(_env))
    res = task.value
    if control.task != task: return
    control.task = null
    if res != null:
        r = repr(res)
        { r == "null"   }: output.addLines("$res".split("\n"))
        {               }: output.addLine(r)
    b.redraw

control.onstop = -> stop()
control.onstart = -> stop(); !start()

dochange = Var.new 0
editor.onchange = ->
    if not control.autorun: return
    $dochange += 1
    !(
        sleep 0.15
        x = ($dochange -= 1)
        if x > 0: return
        stop()
        start()
    )
start()

