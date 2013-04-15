package db;
import sys.db.Object;
import sys.db.Types;

class TestContact extends Object
{
	public var id:SId;
	public var project:String; //the project associated with contact
	public var testName:Null<String>; //optionally, the contact can be associated with a specific test name
	public var name:SString<255>;
	public var email:SString<255>;
}
