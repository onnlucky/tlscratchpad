FONT = { system.platform == "macosx" }: "menlo"
       {                             }: "courier new"
FHEIGHT = 17
FWIDTH = 8
FSIZE = 14

Result = function, in, compare, to -> _Mutable_new {
    // to be a "widget"
    class = widget.widget_class
    parent = null
    x = 0
    y = 0
    width = 0
    height = 0

    error = null
    output = ""
    status = null

    size = g, width, height ->
        this.width = width
        this.height = FHEIGHT

    draw = g, width, height ->
        g.setFont(FONT, FSIZE)

        g.color(1,0.8,0.8)
        if this.status: g.color(0.8,1,0.8)
        g.rectangle(0, 0, width, height)
        g.fill


        line = "$function($(repr in)) $compare $(repr to)"
        line = { this.status }: line
               { this.error  }: "$line (error: $(this.error))"
               {             }: "$line (result: $(repr this.output))"

        g.color(0,0,0)
        y = FHEIGHT - 3
        line.size.times: c ->
            x = c * FWIDTH - FWIDTH
            if x > width: return
            g.moveTo(x, y)
            g.fillText(line[c])

    setError = e ->
        print "ERROR: $e"
        this.status = false
        this.output = null
        this.error = e
        this.parent.dirty

    eval = fn ->
        self = this
        this.error = "unknown"
        this.output = null
        this.status = false
        catch: e -> self.setError(try(e.msg, e) or "unknown")
        this.output = fn(in)
        this.error = null
        this.status = this.output == to
        this.parent.dirty
}
