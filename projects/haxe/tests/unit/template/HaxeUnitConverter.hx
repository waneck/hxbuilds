using StringTools;

class HaxeUnitConverter {

	function new() {

	}

	static inline var TIMEOUT_MS = 500;

	static function main()
	{
		var args = Sys.args();
		var process = new sys.io.Process(args.shift(), args);

		var out = new StringBuf(), err = new StringBuf();
		var stdout = process.stdout, iserr = false;
		var isDone = false;
		try
		{
			while(true)
			{
				var ln = stdout.readLine();
				isDone = ln.indexOf("DONE [") >= 0;
				if (!ln.endsWith("START") && !isDone)
				{
					iserr = true;
					err.add(ln);
					err.add("\n");
				} else {
					out.add(ln);
					out.add("\n");
				}
				if (isDone)
				{
					process.kill();
					break;
				}
			}
		}
		catch(e:haxe.io.Eof) {}
		err.add(process.stderr.readAll());
		var err = err.toString();
		var exit = try process.exitCode() catch(e:Dynamic) 1;
		if (isDone) exit = 0;

		Sys.stdout().writeString(out.toString());
		Sys.stderr().writeString(err);
		if (exit != 0 || iserr || err.length > 0)
		{
			Sys.exit(1);
		}
	}

}
