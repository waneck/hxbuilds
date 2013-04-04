import sys.FileSystem;
import haxe.PosInfos;

using Lambda;

class Build
{
	static var verbose:Bool = false;
	static var version:Null<Int>;
	static var ext = ".sh";

	public static function main()
	{
		var args = Sys.args();
		var arg = 0, len = args.length;
		while(arg < len)
		{
			switch(args[arg++])
			{
			case '--verbose': verbose = true;
			case '-rev': //version
				version = Std.parseInt(args[arg++]);
			default:
				warn("Invalid argument '" + args[arg - 1] + "'");
				usage();
				Sys.exit(-1);
			}
		}

		if (version == null)
		{
			warn("No valid version tag found");
			usage();
			Sys.exit(-2);
		}

		if (args.has("-v"))
			verbose = true;
		if (Sys.systemName == "Windows")
			ext = ".bat";

		for (pf in FileSystem.readDirectory("platforms"))
		{
			if (FileSystem.isDirectory("platforms/" + pf))
			{
				if (platform(pf, "platforms/" + pf) != 0)
				{
					warn("Platform " + pf + " failed");
				}
			}
		}

	}

	private static function usage()
	{
		Sys.println("Usage: builds [--verbose] -v <version>");
		Sys.println("required:");
		Sys.println(" -v <version>: sets the current svn revision to build");
		Sys.println("optional:");
		Sys.println(" --verbose: sets program to verbose mode");
	}

	private static function platform(name:String, path:String):Int
	{
		info("platform " + name);
		//build haxe
		if (FileSystem.exists(path + '/build' + ext))
		{
			var exit = Sys.command(path + '/build' + ext);
			if (exit != 0) return exit;
		}

		//check remote version

	}

	private static function info(x:Dynamic, ?pos:PosInfos)
	{
		if (verbose)
		{
			Sys.println(pos.fileName + ":" + pos.lineNumber + ": " + x);
		}
	}

	private static function warn(x:Dynamic, ?pos:PosInfos)
	{
		Sys.stderr().writeString(pos.fileName + ":" + pos.lineNumber + ": " + x);
	}
}
