import sys.db.Manager;
import sys.FileSystem;
import sys.db.Mysql;
import sys.db.Sqlite;
import sys.io.File;
class Env
{
	private static var data:Dynamic;

	public static function init()
	{
		var file = Sys.getEnv("HOME") + "/.hxtests.json";
		if (!FileSystem.exists(file))
		{
			file = "/etc/hxtests/hxtests.json";
		}

		if (!FileSystem.exists(file))
		{
			Sys.stderr().writeString("Error! Configuration file not found. Run `hxtests config` first\n");
			Sys.exit(2);
		}

		data = haxe.Json.parse( File.getContent(file) );
		if (data.mysql != null)
		{
			Manager.cnx = Mysql.connect(data.mysql);
		} else {
			Manager.cnx = Sqlite.open(data.sqlite);
		}
	}
}
