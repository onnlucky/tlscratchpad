RunControl = -> _Mutable_new {
    // to be a "widget"
    class = widget.widget_class
    parent = null
    visible = true
    x = 0
    y = 0
    width = 0
    height = 20

    autorun = true
    task = null

    size = g, width, height ->
        this.width = width

    draw = g, width, height ->
        g.color(0.3,0.9,0.3)
        if this.task:
            g.color(0.9,0.3,0.3)
        g.rectangle(100, 0, width - 106, height).fill

        t = { this.autorun }: g.color; "autorunning"
            {              }: g.color(0.5,0.5,0.5); "set autorun"
        g.setFont("arial", 14).moveTo(10,15).fillText(t)

    onmouse = event, x, y ->
        if x < 100:
            this.autorun = not this.autorun
            if this.autorun: this.onstart
            this.parent.dirty
            return
        this.autorun = false
        { this.task }: this.onstop
        {           }: this.onstart
        !this.parent.dirty

    onstop = null
    onstart = null
}

