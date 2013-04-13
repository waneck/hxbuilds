package db;
import sys.db.Object;
import sys.db.Types;

@:index(project, name)
class Test extends Object
{
	public var id:SId;
	public var project:SString<255>;
	public var name:SString<25>;
	public var title:Null<SString<255>>;
	public var description:Null<String>;
	public var inUse:SBool; //if deprecated
}
