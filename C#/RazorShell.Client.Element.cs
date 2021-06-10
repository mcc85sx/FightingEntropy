using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RazorShell.Client
{
    public class Element
    {
        public string   String { get; set; } = null;
        public object   Object { get; set; } = null;
        public string     Name { get; set; } = null;
        public string Property { get; set; } = null;
        public object    Value { get; set; } = null;

        public Element(string String, object Object, string Name, string Property, object Value)
        {
            this.String   = String;
            this.Object   = Object;
            this.Name     = Name;
            this.Property = Property;
            this.Value    = Value;
        }
    }
}
