
    public class Window
    {
	    public double height_ { get; set; } = 0;
        public double height  { get; set; } = 0;
        public double  width_ { get; set; } = 0;
        public double  width  { get; set; } = 0;
        public double   side  { get; set; } = 0;
        public double   main  { get; set; } = 0;
        public double  pixel  { get; set; } = 0;

        public Window()
        {
			
        }
		
	public void Set(double width, double height)
	{
		this.width_  =      width;
		this.width   = this.width_;
			this.height_ =      height;
			this.height  = this.height_;
			
			this.side    = width * 0.15;
			this.main    = width * 0.85;
			this.pixel   = width / 1920;
		}
		
		public void Print()
		{
			System.Console.WriteLine("     [Width] = [" + this.width +"]");
			System.Console.WriteLine("    [Height] = [" + this.height +"]");
			System.Console.WriteLine("      [Side] = [" + this.side +"]");
			System.Console.WriteLine("      [Main] = [" + this.main +"]");
			System.Console.WriteLine("     [Pixel] = [" + this.pixel +"]");
		}
    }
		
    public class Sheet
    {
        public object       ID { get; set; } = null;
        public object      Tag { get; set; } = null;
        public object Property { get; set; } = null;
        public object    Value { get; set; } = null;

        public Sheet()
        {
		
        }

        public void Set(object _ID, string _Tag, string _Property, string _Value)
        {
            this.ID = _ID;
            this.Tag = _Tag;
            this.Property = _Property;
            this.Value = _Value;
        }
		
		public void Print()
		{
			System.Console.WriteLine("[" + this.ID +"]");
			System.Console.WriteLine("[" + this.Tag +"]");
			System.Console.WriteLine("[" + this.Property +"]");
			System.Console.WriteLine("[" + this.Value +"]");
		}
    }

	void Main()
	{
		var window = new Window();
		window.Set(1920,1080);
		window.Print();
		
		
	}

// You can define other methods, fields, classes and namespaces here
