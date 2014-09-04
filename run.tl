w = Window.new 400, 800
w.title "widget test"
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

view.add(widget.Text("Create a function that takes a string, and returns the same string, but all in upper case."))
view.add(widget.Text(""))
view.add(Editor("uppercase = s ->", readonly=true))
editor = Editor("  s.upper")
view.add(editor)
editor.setFocus
view.add(widget.Text(""))

result = Result("uppercase", "hello", "==", "HELLO")
view.add(result)

dochange = Var.new 0
editor.onchange = ->
    $dochange += 1
    !(
        catch: e -> print try(e.toString, e)
        sleep 0.3
        x = ($dochange -= 1)
        if x > 0: return

        code = "uppercase = s ->\n" + editor.text
        print "compiling:\n", repr(code)

        catch: e -> result.setError(try(e.msg, e) or "unknown")
        fn, err = code.eval
        print "fn:", fn, err
        result.eval(fn)
    )

editor.onchange
