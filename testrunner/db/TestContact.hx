package db;
import sys.db.Object;
import sys.db.Types;

class TestContact extends Object
{
	public var id:SId;
	@:relation(test_id) public var test:Test;
	public var name:SString<255>;
	public var email:SString<255>;
}
