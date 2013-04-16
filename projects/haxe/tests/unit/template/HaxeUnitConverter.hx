using StringTools;

class HaxeUnitConverter {

	function new() {

	}

	static function main()
	{
		var args = Sys.args();
		var process = new sys.io.Process(args.shift(), args);

		var out = new StringBuf(), err = new StringBuf();
		var stdout = process.stdout, iserr = false;
		try
		{
			while(true)
			{
				var ln = stdout.readLine();
				if (!ln.endsWith("START") && ln.indexOf("DONE [") == -1)
				{
					iserr = true;
					err.add(ln);
					err.add("\n");
				} else {
					out.add(ln);
					out.add("\n");
				}
			}
		}
		catch(e:haxe.io.Eof) {}
		err.add(process.stderr.readAll());
		var err = err.toString();
		var exit = process.exitCode();

		Sys.stdout().writeString(out.toString());
		Sys.stderr().writeString(err);
		if (exit != 0 || iserr || err.length > 0)
		{
			Sys.exit(1);
		}
	}

}
