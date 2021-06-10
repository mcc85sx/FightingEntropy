using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.JSInterop;

namespace RazorShell.Client
{
    public class Style
    {
        public string[] Tags { get; set; } = { "t0", "t1", "t2", "t3", "t4", "t5", "t6" };
        public string[] Names { get; set; } = { "Home", "App Development", "Network Security", "Enterprise", "OS Management", "Hardware", "Data Management" };

        public string Slot { get; set; } = null;
        public string Logo { get; set; } = null;
        public string ID { get; set; } = null;

        Style()
        {

        }
    }
}
