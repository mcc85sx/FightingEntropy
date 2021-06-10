using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RazorShell.Client
{
    public class Stage
    {
        public string[]     Element { get; set; } = { "--root", "--side", "--main", "--pixel" };
        public object[]        Unit { get; set; } = new object[4];
        public string[]        Name { get; set; } = { "#top", "#side", "body", "#main" };
        public string[]    Property { get; set; } = { "display", "display", "flex-direction", "--content" };
        public string[]       Value { get; set; } = new string[4];
        public object[]      Output { get; set; } = new Element[4];

        public Stage(Window Window, string ID)
        {
            this.Unit[0] = Window.width;
            this.Unit[1] = Window.side;
            this.Unit[2] = Window.main;
            this.Unit[3] = Window.pixel;

            if (ID == "Compact")
            {
                this.Value[0] = "none";
                this.Value[1] = "flex";
                this.Value[2] = "row";
                this.Value[3] = Window.main + "px";
            }

            if (ID == "Full")
            {
                this.Value[0] = "flex";
                this.Value[1] = "none";
                this.Value[2] = "column";
                this.Value[3] = Window.width + "px";
            }

            for (var x = 0; x <= 3; x++)
            {
                this.Output[x] = new Element(this.Element[x], this.Unit[x], this.Name[x], this.Property[x],this.Value[x]);
            }
        }
    }
}
