void Main()
{
	string[] ID = {"Welcome to my C# Hello world program that I made in a couple minutes...",
				   "Normally, I would write this in PowerShell.",
				   "However, there are some huge benefits to be had, when working directly with...",
				   "Your standard issue loadout... of C friggen Sharp.",
				   "C# for short. C is a language from back in the day, it has had multiple clones.",
				   "All C based languages have a common denominator,",
				   "regardless of how different their programming paradigms are.",
				   "Anyway- check this out..."};

	foreach (string item in ID)
	{
		Console.WriteLine(item);
	};
	
	Console.ReadLine();
}
