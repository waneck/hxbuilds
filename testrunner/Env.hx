import sys.db.Manager;
import sys.db.Mysql;
import sys.io.File;
class Env
{
	public static function init()
	{
		var sqlData = haxe.Json.parse( File.getContent( Sys.getEnv("HOME") + "/.testrunnerData") );

		Manager.cnx = Mysql.connect(sqlData);
	}
}
