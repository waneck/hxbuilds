package db;
import sys.db.Object;
import sys.db.Types;

@:index(test_id, name, unique)
class TestPart extends Object
{
	public var id:SId;
	@:relation(test_id) public var test:Test;
	public var name:SString<25>;
	public var title:Null<SString<255>>;
	public var description:Null<String>;
}
