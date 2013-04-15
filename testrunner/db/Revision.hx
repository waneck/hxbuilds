package db;
import sys.db.Object;
import sys.db.Types;

@:index(project,revision,unique)
@:index(firstRun)
class Revision extends Object
{
	public var id:SId;
	public var project:SString<255>;
	public var revision:SString<255>; //A String that represents the version. Can support DVCS
	public var firstRun:SDateTime; //date of the first time revision was run
	public var author:Null<SString<255>>;
	public var date:Null<SDateTime>; //commit date
	public var log:Null<SText>;
}
